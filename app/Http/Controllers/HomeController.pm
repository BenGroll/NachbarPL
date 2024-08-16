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
        name => user() ? user()->get('email') : 'Nachbar/dev',
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
        headline => 'Sign-In',
    })->output();
}

sub profile {
    my $self = shift;
    my $request = shift;

    return &_::template('profile', {
        first_name => 'Test',
        last_name => 'Tester',
        email => Models::User::find(&_::authUser())->get('email'),
    }, {
        headline => 'Profile',
    })->output();
}

1;
