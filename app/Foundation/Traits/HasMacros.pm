package Foundation::Traits::HasMacros;

use strict;
use warnings;

use Foundation::Appify;

use Exporter 'import';

our @EXPORT = qw(
    AUTOLOAD
);

our $AUTOLOAD;

sub AUTOLOAD {
    my $self = shift;
    
    my $class = ref $self;

    my @parts = split '::', $AUTOLOAD;

    my $method = pop @parts;

    $main::macros ||= {};

    unless ($main::macros->{$class} && $main::macros->{$class}->{$method}) {
        die "Can't locate object method \"$method\" via package \"$class\"";
    }

    my $macro = $main::macros->{$class}->{$method};

    return &$macro($self, @_);
}

1;
