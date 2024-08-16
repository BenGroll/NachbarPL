package Http::Middlewares::Admin;

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

    unless (1) {
        &_::abort('Unauthenticated.', 403);
    }

    return &$next($request);
}

1;
