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
            isadmin => 0,
            name => undef,
            surname => undef,
            created_at => undef,
            updated_at => undef,
        }
    };
    bless $self, $class;

    $self->fill($attributes);

    return $self;
}

sub name {
    my $self = shift;

    return $self->{attributes}->{name} . " " . $self->{attributes}->{surname};
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
    # die $attributes;
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

sub isadmin {
    my $self = shift;

    return $self->{attributes}->{isadmin};
}

sub hasPermission {
    my $self = shift;
    my $permissionName = shift;

    return 1 if ($self->isadmin);

    my $dbh = &_::app()->database();

    my $sql = sprintf(
        'SELECT * FROM %s WHERE `%s` = ? LIMIT 1',
        'users_permissions_table',
        'permission'
    );

    my $sth = $dbh->prepare($sql);
    $sth->execute($permissionName) or die $sth->errstr;
    
    return ($sth->fetchrow_hashref) ? 1 : 0;
}

sub givePermission {
    my $self = shift;
    my $assignedByUser = shift;
    my $permissionName = shift;

    my $dbh = &_::app()->database();

    my $sql = qq 'INSERT INTO users_permissions_table 
        (user_id, permission, assigned_by, assigned_at) VALUES 
        (?, ?, ?, ?)';
    
    my $sth = $dbh->prepare($sql);
    $sth->execute($self->id, $permissionName, $assignedByUser->id)
        or die $sth->errstr;
}

1;
