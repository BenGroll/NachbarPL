package Http::Router;

use strict;
use warnings;

use Foundation::Appify;

sub new {
    my $class = shift;

    my $self = {
        booted => 0,
        file => '/routes/web.pl',
        routes => {},
        names => {},
        fallback_method => '__invoke',
    };
    bless $self, $class;

    return $self;
}

sub boot {
    my $self = shift;

    if ($self->{booted}) {
        return;
    }

    require &_::app()->basePath() . $self->{file};

    $self->{booted} = 1;

    return $self;
}

sub find {
    my $self = shift;
    my $path = shift;

    $path =~ s/\/$//;

    
    my $route = $self->{routes}->{$path} || $self->{routes}->{$path . '/'};
    
    if ($route) {
        return $route;
    }

    return $self->findWithParameters($path);
}

sub findWithParameters {
    my $self = shift;
    my $path = shift;

    foreach my $key (keys %{$self->{routes}}) {

        my ($match, $parameters) = $self->matchPathWithRoute($path, $key);

        unless ($match) {
            next;
        }

        # Deep copy the matched route so that we can safely extend it without
        # altering the route table itself.
        my %route = %{$self->{routes}->{$key}};

        if (keys %{$parameters}) {
            $route{parameters} = $parameters;
        }

        return \%route;
    }

    return;
}

sub matchPathWithRoute {
    my $self = shift;
    my $path = shift;
    my $routeKey = shift;

    my @pathParts = split('/', $path);
    my @routeKeyParts = split('/', $routeKey);

    unless (@pathParts == @routeKeyParts) {
        return;
    }

    my %parameters;

    for (my $i = 0; $i < @pathParts; $i++) {

        my $pathPart = $pathParts[$i];
        my $routeKeyPart = $routeKeyParts[$i];

        if ($pathPart eq $routeKeyPart) {
            next;
        }

        if ($routeKeyPart =~ /\{(.+)\}/) {
            %parameters = (%parameters, ($1 => $pathPart));
            next;
        }

        return;

    }

    return 1, \%parameters;
}

sub dispatch {
    my $self = shift;
    my $route = shift;
    my $request = shift;

    my @middlewares = (

        'Http::Middlewares::BindRouteParametersToRequest',

        @{$route->{middlewares} || []},

        'Http::Middlewares::EnsureMeaningfulResponse',
    );

    my $result = &_::app()->make('Foundation::Pipeline')->send(
        $request,
    )->through(
        \@middlewares,
    )->then(sub {
        my $request = shift;

        my $package = $route->{package};

        if (ref $package eq 'CODE') {
            return &$package($request);
        }

        my $instance = &_::app()->make($package);
        my $method = $route->{method} || $self->{fallback_method};

        return $instance->$method($request);
    });
}

1;
