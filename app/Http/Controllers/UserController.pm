package Http::Controllers::UserController;

use strict;
use warnings;

use Models::User;
use Foundation::Appify;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub register {
    my $self = shift;
    my $request = shift;


    my $email = $request->param('email');
    my $password = $request->param('password');
    my $passwordConfirmation = $request->param('password_confirm');

    unless ($email) {
        &_::abort('No email given.');
    }

    app()->dispatch(make(
        'Foundation::Events::ValidatingPassword',
        $password,
        $passwordConfirmation,
    ));

    unless ($password) {
        &_::abort('No password given.');
    }

    unless ($password eq $passwordConfirmation) {
        &_::abort('The password does not match its confirmation.', 422);
    }

    if (Models::User::retrieve($email)) {
        &_::abort("The email does already exist: $email", 422);
    }

    my ($hash, $salt) = &_::app()->hash($password);

    my $user = Models::User->new({
        email => $email,
        password => $hash,
        salt => $salt,
        isadmin => 1,
    })->save(1);

    &_::session()->update({
        user_id => $user->id(),
    });

    app()->dispatch(make(
        'Foundation::Events::Users::Registered',
        $user,
    ));

    return response()->redirect('/', [
        'Registered successfully',
    ]);
}

sub login {
    my $self = shift;
    my $request = shift;

    my $email = $request->param('email');
    my $password = $request->param('password');

    my $user = Models::User::retrieve($email);

    unless ($user) {
        &_::abort("Unable to find user: [$email]", 404);
    }

    my ($hash, $salt) = &_::app()->hash($password, $user->get('salt'));

    unless ($hash eq $user->get('password')) {
        &_::abort('Password incorrect.', 422);
    }

    &_::session()->update({
        user_id => $user->id(),
    });

    app()->dispatch(make(
        'Foundation::Events::Users::Authenticated',
        $user,
    ));

    return response()->redirect('/', [
        'Signed in successfully',
    ]);
}

sub logout {
    my $self = shift;
    my $request = shift;

    &_::session()->update({
        user_id => undef,
    });

    return response()->redirect('/', [
        'Signed out successfully',
    ]);
}

1;
