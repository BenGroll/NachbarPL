package Foundation::Events::EventManager;

use strict;
use warnings;

use Foundation::Appify;

sub new {
    my $class = shift;
    my $basePath = shift;

    my $self = {
        events => {}
    };
    bless $self, $class;

    return $self;
}

sub subscribe {
    my $self = shift;
    my $eventName = shift;
    my $callback = shift;

    $self->{events}->{$eventName} ||= [];

    push @{$self->{events}->{$eventName}}, $callback;

    return $self;
}

sub dispatch {
    my $self = shift;
    my $event = shift;

    my $eventName = ref $event;
    
    foreach my $listener (@{$self->{events}->{$eventName} || []}) {
        &$listener($event);
    }

    return $self;
}

1;
