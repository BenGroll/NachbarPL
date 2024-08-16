package Bootstrappers::Events;

use strict;
use warnings;

use Foundation::Appify;

sub new {
    my $class = shift;
    my $basePath = shift;

    my $self = {

    };
    bless $self, $class;

    return $self;
}

sub bootstrap {
    my $self = shift;
    my $app = shift;

    $app->singleton('Foundation::Events::EventManager');

    macro('App', 'dispatch', sub {
        my $self = shift;

        $app->make('Foundation::Events::EventManager')->dispatch(@_);
    });

    macro('App', 'subscribe', sub {
        my $self = shift;

        $app->make('Foundation::Events::EventManager')->subscribe(@_);
    });


    return;
}

1;
