package Http::Middlewares::UserHasPermission;

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
    my $params = shift;

    unless (1) {
        &_::abort('Unauthenticated.', 403);
    }

    return &$next($request);
}

1;
