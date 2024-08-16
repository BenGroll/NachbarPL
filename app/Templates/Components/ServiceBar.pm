package Templates::Components::ServiceBar;

use parent qw(
    Foundation::Component
);

use strict;
use warnings;

use Foundation::Appify;

sub render {
    my $self = shift;

    my $providers = &_::app()->providers();

    my @services;
    foreach my $provider (@{$providers}) {
        my $gateway = $provider->gateway();
        unless ($gateway) {
            next;
        }

        my $link = $gateway->{link};

        if ($ENV{PATH_INFO} =~ /^$link$/ || $ENV{PATH_INFO} =~ /^$link\//) {
            $gateway->{active} = 1;
        }

        push @services, $gateway;
    }

    return $self->template('components.service-bar', {
        services => \@services,
    });
}

1;
