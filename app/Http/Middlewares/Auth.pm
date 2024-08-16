package Http::Middlewares::Auth;

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

    unless (&_::app()->authUser()) {
        &_::abort('Unauthenticated.', 403);
    }

    return &$next($request);
}

1;
