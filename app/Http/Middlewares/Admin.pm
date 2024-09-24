package Http::Middlewares::Admin;

use strict;
use warnings;

use Foundation::Appify;

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

    unless (user()->isadmin) {
        &_::abort('Unauthenticated.', 403);
    }

    return &$next($request);
}

1;
