package Foundation::Appify;

use strict;
use warnings;

use Models::User;
use Exporter 'import';

our @EXPORT = qw(
    app
    info
    user
    tmpl
    component
    session
    abort
    make
    singleton
    dd
    env
    config
    basePath
    appPath
    servicePath
    response
    macro
);

sub tmpl {
    return &_::app()->template(@_);
}

sub session {
    return &_::app()->session(@_);
}

sub abort {
    return &_::app()->abort(@_);
}

sub make {
    return &_::app()->make(@_);
}

sub singleton {
    return &_::app()->singleton(@_);
}

sub dd {
    return &_::app()->dd(@_);
}

sub env {
    return &_::app()->env(@_);
}

sub config {
    return &_::app()->config(@_);
}

sub basePath {
    return &_::app()->basePath(@_);
}

sub appPath {
    return &_::app()->appPath(@_);
}

sub servicePath {
    return &_::app()->servicePath(@_);
}

sub app {
    return &_::app();
}

sub info {
    return app()->log(@_);
}

sub user {
    return Models::User::find(app()->authUser());
}

sub guest {
    return user() ? 1 : undef;
}

sub response {
    return app()->make('Http::Response', @_);
}

sub macro {
    my $class = shift;
    my $name = shift;
    my $macro = shift;

    $main::macros ||= {};
    $main::macros->{$class} ||= {};

    if ($main::macros->{$class}->{$name}) {
        die "Macro does already exist for [$class]: [$name]";
    }

    $main::macros->{$class}->{$name} = $macro;

    return;
}

1;
