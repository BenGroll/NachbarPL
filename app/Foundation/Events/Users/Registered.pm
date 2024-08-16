package Foundation::Events::Users::Registered;

use parent qw(
    Foundation::Events::Event
);

use strict;
use warnings;

use Foundation::Appify;

sub new {
    my $class = shift;
    my $user = shift;

    my $self = {
        user => $user,
    };

    bless $self, $class;

    return $self;
}

sub user {
    return shift->{user};
}

1;
