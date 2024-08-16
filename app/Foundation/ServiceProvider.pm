package Foundation::ServiceProvider;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $config = shift || {};

    my $self = {
        config => $config,
    };

    bless $self, $class;

    return $self;
}

sub register {
    my $self = shift;

    unshift @INC, $self->{config}->{dir} . '/src';
}

sub boot {
    my $self = shift;

    my $routesFile = $self->{config}->{dir} . '/routes/web.pl';
    if (-f $routesFile) {
        require $routesFile;
    }
}

sub gateway {
    my $self = shift;

    return {
        link => $self->{config}->{link},
        name => $self->{config}->{name},
    };
}

sub listeners {
    my $self = shift;

    return {};
}

sub TO_JSON {
    return shift->{config};
}

1;
