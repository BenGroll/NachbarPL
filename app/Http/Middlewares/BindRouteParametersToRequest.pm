package Http::Middlewares::BindRouteParametersToRequest;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub handle {
    my $self = shift;
    my $request = shift;
    my $next = shift;
    my $args = shift;

    my $route = $request->param('__route__');

    unless ($route->{parameters}) {
        return &$next($request);
    }

    foreach my $key (keys %{$route->{parameters}}) {

        my $value = $route->{parameters}->{$key};

        if ($request->param($key)) {
            next;
        }

        $request->append(
            -name => $key,
            -values => $value,
        );

    }

    return &$next($request);
}

1;
