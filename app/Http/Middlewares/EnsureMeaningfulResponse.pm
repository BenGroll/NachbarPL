package Http::Middlewares::EnsureMeaningfulResponse;

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

    my $result = &$next($request);

    if (ref $result eq 'Http::Response') {
        return $result;
    }

    my $response = Http::Response->new();
    $response->setBody($result);

    return $response;
}

1;
