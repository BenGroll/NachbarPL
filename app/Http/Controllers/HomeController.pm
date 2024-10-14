package Http::Controllers::HomeController;

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

sub index {
    my $self = shift;
    my $request = shift;

    return &_::template('welcome', {
        greeting => user() ? user()->get('name') : ', please log in or create an account.',
    }, {
        title => 'Welcome',
    })->output();
}

sub register {
    my $self = shift;
    my $request = shift;

    return &_::template('register', {
        'email_label' => 'Email',
        'password_label' => 'Password',
        'password_confirm_label' => 'Password Confirmation',
        'name_label' => 'Name',
        'surname_label' => 'Surname',
        'submit' => 'Register',
    }, {
        headline => 'Sign-Up'
    })->output();
}

sub login {
    my $self = shift;
    my $request = shift;

    return &_::template('login', {
        'email_label' => 'Email',
        'password_label' => 'Password',
        'submit' => 'Login',
    }, {
        headline => 'Log-In',
    })->output();
}

sub profile {
    my $self = shift;
    my $request = shift;

    my $user = Models::User::find(&_::authUser());

    return &_::template('profile', {
        name => $user->get('name'),
        surname => $user->get('surname'),
        email => $user->get('email'),
    }, {
        headline => 'Profile',
    })->output();
}

1;
