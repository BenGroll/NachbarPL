package Models::Model;

use strict;
use warnings;
use DateTime;
use JSON;
use Scalar::Util 'refaddr';

sub new {
    my $class = shift;
    my $attributes = shift;

    my $self = {
        table => '',
        route_key => '',
        attributes => {}
    };
    bless $self, $class;

    $self->fill($attributes);

    return $self;
}

sub table {
    return shift->{table};
}

sub routeKey {
    return shift->{route_key};
}

sub id {
    return shift->{attributes}->{id};
}

sub fill {
    my $self = shift;
    my $attributes = shift || {};

    my @keys = keys %{$self->{attributes}};
    foreach my $key (keys %{$attributes}) {
        unless ($self->has($key)) {
            next;
        }
        $self->set($key, $attributes->{$key});
    }

    return $self;
}

sub exists {
    return shift->id() ? 1 : undef;
}

sub all {
    return shift->{attributes};
}

sub has {
    my $self = shift;
    my $attribute = shift;

    my @keys = keys %{$self->{attributes}};
    foreach my $key (@keys) {
        if ($attribute eq $key) {
            return 1;
        }
    }

    return;
}

sub set {
    my $self = shift;
    my $attribute = shift;
    my $value = shift;

    $self->{attributes}->{$attribute} = $value;

    return $self;
}

sub get {
    my $self = shift;
    my $attribute = shift;

    return $self->{attributes}->{$attribute};
}

sub cast {
    my $self = shift;
    my $value = shift;

    unless (ref $value) {
        return $value;
    }

    if (ref $value eq 'HASH' || ref $value eq 'ARRAY') {
        return encode_json($value);
    }

    # At this point we could implement some logic to extract meaningful values
    # from the object in question given it is one.

    return;
}

sub save {
    my $self = shift;
    my $includeID = shift;
    my $attributes = shift;

    $attributes ||= $self->all();

    unless ($includeID) {
        delete $attributes->{id};
    }
    $attributes->{created_at} = DateTime->now()->datetime(' ');
    $attributes->{updated_at} = DateTime->now()->datetime(' ');

    my ($keys, $values) = $self->prepare($attributes);

    my $mask = '';
    foreach my $key (@{$keys}) {
        $mask .= '?,';
    }
    $mask =~ s/\,$//;

    my $sql = sprintf(
        'INSERT INTO %s (%s) VALUES (%s)',
        $self->table(),
        join(',', @{$keys}),
        $mask,
    );

    # die $sql;

    my ($dbh, $sth) = $self->runSqlStatement($sql, $values);

    unless ($includeID) {
        $self->set('id', $dbh->last_insert_id());
    }

    unless ($self->id()) {
        die 'Failed to save model: [' . ref $self .  ']'
    }

    return $self;
}

sub update {
    my $self = shift;
    my $attributes = shift;

    $attributes ||= $self->all();

    unless ($self->exists()) {
        die 'Model does not exist: [' . ref $self . ']'; 
    }

    $attributes->{updated_at} = DateTime->now()->datetime(' ');

    my ($keys, $values) = $self->prepare($attributes);

    my $sql = sprintf(
        'UPDATE %s SET ',
        $self->table(),
    );

    foreach my $key (@{$keys}) {
        $sql .= $key . ' = ?,';
    }
    $sql =~ s/\,$//;

    $sql .= sprintf(
        ' WHERE `id` = ?',
        $self->table(),
    );

    push @{$values}, $self->id();

    $self->runSqlStatement($sql, $values);

    return $self;
}

sub prepare {
    my $self = shift;
    my $attributes = shift;

    my @keys = keys %{$attributes};
    my @values = values %{$attributes};

    foreach my $value (@values) {
        $value = $self->cast($value);
    }

    return \@keys, \@values;
}

sub runSqlStatement {
    my $self = shift;
    my $sql = shift;
    my $values = shift;

    my $dbh = &_::app()->database();
    my $sth = $dbh->prepare($sql);
    $sth->execute(@{$values}) or die $sth->errstr;

    return $dbh, $sth;
}

sub TO_JSON {
    my $self = shift;

    return ref($self) . '@' . refaddr($self);
}

1;
