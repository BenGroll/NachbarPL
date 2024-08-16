package Foundation::Pipeline;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $basePath = shift;

    my $self = {
        pipes => [],
        destination => undef,
        item => undef,
    };
    bless $self, $class;

    return $self;
}

sub send {
    my $self = shift;
    my $item = shift;

    $self->{item} = $item;

    return $self;
}

sub through {
    my $self = shift;
    my $pipes = shift;

    unless (ref $pipes eq 'ARRAY') {
        $pipes = [$pipes];
    }

    $self->{pipes} = $pipes;

    return $self;
}

sub then {
    my $self = shift;
    my $destination = shift;

    unless (ref $destination eq 'CODE') {
        die 'Pipeline destination must be a closure.';
    }

    $self->{destination} = $destination;

    my $result = eval {
        my $callable = $self->next();
        return &$callable($self->{item});
    }; if ($@) {
        $self->handleException($@);
    }

    return $result;
}

sub next {
    my $self = shift;

    my $pipe = shift @{$self->{pipes}};
    if ($pipe) {
        return sub {
            my $item = shift;

            my $next = $self->next();
            if (ref $pipe eq 'CODE') {
                return &$pipe($item, $next);
            }

            return &_::app()->make($pipe)->handle($item, $next);
        }
    }
    return $self->{destination};
}

sub handleException {
    my $self = shift;
    my $message = shift;

    my $handler = $self->{exception_handler};

    unless (defined $handler) {
        die $message;
    }
    if (ref $handler eq 'CODE') {
        return &$handler($message);
    }
    return $handler->handle($message);
}

1;
