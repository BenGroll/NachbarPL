package Bootstrappers::Services;

use strict;
use warnings;

use Foundation::Appify;

sub new {
    my $class = shift;
    my $basePath = shift;

    my $self = {
        dir => '/services',
        filename => '/service.json',
        permissionfilename => '/permissions.json'
    };
    bless $self, $class;

    return $self;
}

sub bootstrap {
    my $self = shift;
    my $app = shift;

    my $base = $app->basePath() . $self->{dir};

    unless (-d $base) {
        return;
    }

    opendir my $dh, $base or die "Unable to open dir [$base]: $!";

    my %register;
    my @services;
    my @total_permissions;
    
    while (my $item = readdir($dh)) {

        if ($item eq '.' || $item eq '..') {
            next;
        }

        my $dir = $base . "/$item";
        unless (-d $dir) {
            next;
        }

        my $file = $dir . '/' . $self->{filename};
        unless (-f $file) {
            next;
        }

        my $permissionfile = $dir . $self->{permissionfilename};
        # die $permissionfile;

        if (-f $permissionfile) {
            my $permissions = $app->readJson($permissionfile);
            # use Data::Dumper;
            # die Dumper($permissions);
            push @total_permissions, @$permissions if ($permissions);
        }

        my $config = $app->readJson($file);
        
        my $name = $config->{name};
        my $file = $config->{provider};

        unless ($name) {
            die "Unable to find name of service.";
        }

        if ($register{$name}) {
            die "Service with same name found: [$name]";
        }

        unless ($file) {
            die "Unable to find provider file of service: [$name]";
        }

        my $serviceDir = $base . "/$item";

        $file = $serviceDir . $file;
        
        $config->{dir} = $serviceDir;
        $config->{provider} = $file;

        $register{$name} = 1;

        push @services, $config;

    }

    closedir $dh;

    my $providers = $self->getProviders(\@services);

    if (scalar @total_permissions > 0) {
        $app->registerServicePermissions(\@total_permissions);
    }

    $self->registerServiceManager($app, $providers);

    $self->registerServices($app, $providers);

    $self->bootServices($app, $providers);

    return;
}

sub registerServiceManager {
    my $self = shift;
    my $app = shift;
    my $providers = shift || {};

    macro('App', 'providers', sub {
        return $providers;
    });

    return;
}

sub getProviders {
    my $self = shift;
    my $services = shift || [];

    my @providers;

    foreach my $service (@{$services}) {
        my $file = $service->{provider};
        
        require $file;

        my @parts;

        foreach my $part (split('/', $service->{provider})) {

            # Skip empty parts
            if ($part eq '') {
                next;
            }

            # Skip parts that start with a lower case letter.
            unless ($part =~ /^\p{Lu}/) {
                next;
            }

            push @parts, $part;
        }

        my $package = join('::', @parts);

        $package =~ s/\.pm$//g;

        $package = $service->{name} . '::' . $package;

        push @providers, $package->new($service);
    }

    return \@providers;
}

sub registerServices {
    my $self = shift;
    my $app = shift;
    my $providers = shift || [];

    foreach my $provider (@{$providers}) {
        if ($provider->can('register')) {
            $provider->register($app);
        }
    }

    return $self;
}

sub bootServices {
    my $self = shift;
    my $app = shift;
    my $providers = shift || [];

    foreach my $provider (@{$providers}) {
        if ($provider->can('boot')) {
            $provider->boot($app);
        }
    }

    return $self;
}

1;
