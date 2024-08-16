package Models::Session;
use base Models::Model;

use strict;
use warnings;

use JSON;

sub new {
    my $class = shift;
    my $attributes = shift;

    my $self = {
        table => 'sessions',
        route_key => 'token',
        attributes => {
            id => undef,
            user_id => undef,
            token => undef,
            content => {},
            created_at => undef,
            updated_at => undef,
        }
    };
    bless $self, $class;

    $self->fill($attributes);

    return $self;
}

sub remember {
    my $self = shift;
    my $key = shift;
    my $value = shift;

    my $content = decode_json($self->{attributes}->{content});

    $content->{$key} = $value;

    $self->update({
        content => encode_json($content),
    });

    return 1;
}

sub forget {
    my $self = shift;
    my $key = shift;

    my $content = decode_json($self->{attributes}->{content});

    unless ($content->{$key}) {
        return;
    }

    delete $content->{$key};

    $self->update({
        content => encode_json($content),
    });

    return 1;
}

sub retrieve {
    my $token = shift;

    chomp $token;

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
