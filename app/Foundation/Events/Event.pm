package Foundation::Events::Event;

use strict;
use warnings;

use Foundation::Appify;

sub new {
    my $class = shift;
    my $basePath = shift;

    my $self = {
 
    };
    bless $self, $class;

    return $self;
}

1;
