package Bootstrappers::Database;

use strict;
use warnings;
use DBI;

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

    my $credentials = $app->env('database');

    my $source = sprintf(
        'dbi:mysql:database=%s;host=%s;port=%s',
        $credentials->{name},
        $credentials->{host},
        $credentials->{port},
    );

    # use Data::Dumper;
    # die Dumper({credentials => $credentials, source => $source});

    my $dbh = DBI->connect(
        $source,
        $credentials->{user},
        $credentials->{password},
    ) or die 'Unable to connect to database: ' . DBI->errstr;

    $app->setDatabaseHandler($dbh);

    return;
}

1;
