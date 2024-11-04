package Foundation::ServiceProvider;

use strict;
use warnings;

use Foundation::Appify;

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

    return 0 unless (user());

    if ($self->{config}->{onlyAdmin}) {
        return 0 unless(user() && user()->isadmin);
    }
    return 0 unless(user()->hasPermission($self->{config}->{name}));

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
