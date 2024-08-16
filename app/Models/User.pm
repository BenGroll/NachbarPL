package Models::User;
use base Models::Model;

use strict;
use warnings;

use Foundation::Traits::HasMacros;

sub new {
    my $class = shift;
    my $attributes = shift;

    my $self = {
        table => 'users',
        route_key => 'email',
        attributes => {
            id => undef,
            email => undef,
            password => undef,
            salt => undef,
            created_at => undef,
            updated_at => undef,
        }
    };
    bless $self, $class;

    $self->fill($attributes);

    return $self;
}

sub find {
    my $id = shift;

    my $model = __PACKAGE__->new();

    my $dbh = &_::app()->database();

    my $sql = sprintf(
        'SELECT * FROM %s WHERE `id` = ? LIMIT 1',
        $model->table(),
    );

    my $sth = $dbh->prepare($sql);
    $sth->execute($id) or die $sth->errstr;

    my $attributes = $sth->fetchrow_hashref();
    unless ($attributes) {
        return;
    }

    return $model->fill($attributes);
}

sub retrieve {
    my $token = shift;

    my $model = __PACKAGE__->new();

    my $dbh = &_::app()->database();

    my $sql = sprintf(
        'SELECT * FROM %s WHERE `%s` = ? LIMIT 1',
        $model->table(),
        $model->routeKey(),
    );

    my $sth = $dbh->prepare($sql);
    $sth->execute($token) or die $sth->errstr;

    my $attributes = $sth->fetchrow_hashref();
    unless ($attributes) {
        return;
    }

    return $model->fill($attributes);
}

1;
