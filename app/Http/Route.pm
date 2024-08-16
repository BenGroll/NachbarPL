package Http::Route;

use strict;
use warnings;

use JSON;

our $_options = [];

sub new {
    my $class = shift;
    my $method = shift;
    my $route = shift;
    my $endpoint = shift;

    my $self = {
        router => &_::app()->singleton('Http::Router'),
        method => $method,
        route => $route,
        name => undef,
        endpoint => $endpoint,
    };

    bless $self, $class;

    $self->register();

    return $self;
}

sub fullyQualifiedRoute {
    my $self = shift;

    return $self->{method} . $self->{route};
}

sub register {
    my $self = shift;

    my $package = $self->{endpoint};
    my $method = undef;
    unless (ref $package eq 'CODE') {
        my @parts = split '@', $package;
        $package = shift @parts;
        $method = shift @parts;
    }

    my $options = {
        'package' => $package,
        method => $method,
    };

    # Backup a potential already existing route so that we can register it again
    # in case a prefix had been set for the new route. If no prefix had been set
    # we are going to assume that the developer wants to overwrite that route. 
    my $oldRoute = $self->fullyQualifiedRoute();
    my $oldOptions = $self->{router}->{routes}->{$oldRoute};

    $self->{router}->{routes}->{$oldRoute} = $options;

    # The prefixes have to be added in reverse so that the most inner prefix
    # will the last one added.
    foreach my $options (reverse @{$_options}) {
        if (my $prefix = $options->{prefix}) {
            $self->prefix($prefix);

            # In case there are options from a backed up route available we have
            # to register these again.
            if ($oldOptions) {
                $self->{router}->{routes}->{$oldRoute} = $oldOptions;
            }
        }
    }

    # Middlewares on the other hand have to be added as is.
    foreach my $options (@{$_options}) {
        foreach my $middleware (@{$options->{middlewares} || []}) {
            $self->middleware($middleware);
        }
    }

    return;
}

sub middleware {
    my $self = shift;
    my $middleware = shift;

    my $route = $self->fullyQualifiedRoute();
    unless ($self->{router}->{routes}->{$route}->{middlewares}) {
        $self->{router}->{routes}->{$route}->{middlewares} = [];
    }

    push @{$self->{router}->{routes}->{$route}->{middlewares}}, $middleware;

    return $self;
}

sub prefix {
    my $self = shift;
    my $prefix = shift;

    my $oldRoute = $self->fullyQualifiedRoute();

    my $options = $self->{router}->{routes}->{$oldRoute};

    delete $self->{router}->{routes}->{$oldRoute};

    $self->{route} = $prefix . $self->{route};

    $self->{router}->{routes}->{$self->fullyQualifiedRoute()} = $options;

    return $self;
}

sub as {
    my $self = shift;
    my $prefix = shift;

    my $route = $self->{router}->{names}->{$self->{name}};

    unless ($route) {
        return;
    }

    delete $self->{router}->{names}->{$self->{name}};

    $self->{name} = $prefix . $self->{name};

    $self->{router}->{names}->{$self->{name}} = $route;

    return $self;
}

sub name {
    my $self = shift;
    my $name = shift;

    $self->{name} = $name;
    $self->{router}->{names}->{$self->{name}} = $self->fullyQualifiedRoute();

    foreach my $options (reverse @{$_options}) {
        if (my $prefix = $options->{as}) {
            $self->as($prefix);
        }
    }
}

sub json {
    my $file = shift;

    my $router = &_::app()->singleton('Http::Router');

    my $routes = decode_json(&_::app()->read($file));

    $router->{routes} = {(
        %{$router->{routes}},
        %{$routes},
    )};

    return;
}

sub get {
    my $route = shift;
    my $endpoint = shift;

    my $route = Http::Route->new('GET', $route, $endpoint);

    return $route;
}

sub post {
    my $route = shift;
    my $endpoint = shift;

    my $route = Http::Route->new('POST', $route, $endpoint);

    return $route;
}

sub group {
    my $options = shift;
    my $closure = shift;

    unless (keys %{$options}) {
        return;
    }

    push @{$_options}, $options;

    &$closure();

    pop @{$_options};
}

1;
