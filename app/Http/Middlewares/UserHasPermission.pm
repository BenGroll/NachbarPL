package Http::Middlewares::UserHasPermission;

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
    my $params = shift;

    unless (user() && user()->hasPermission($params)) {
        &_::abort("You dont have permission $params.", 403);
    }

    return &$next($request);
}

1;
