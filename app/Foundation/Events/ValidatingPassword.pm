package Foundation::Events::ValidatingPassword;

use parent qw(
    Foundation::Events::Event
);

use strict;
use warnings;

use Foundation::Appify;

sub new {
    my $class = shift;
    my $password = shift;
    my $passwordConfirmation = shift;

    my $self = {
        password => $password,
        password_confirmation => $passwordConfirmation,
    };

    bless $self, $class;

    return $self;
}

sub password {
    return shift->{password};
}

sub passwordConfirmation {
    return shift->{password_confirmation};
}

1;
