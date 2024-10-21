package Repositories::Repository;

sub new {
    my $class = shift;
    my $modelclass = shift;
    my $tablekey = shift;

    my $self = {
        modelclass => $modelclass,
        tablekey => $tablekey,
    };  
    
    bless($self, $class);
}

sub all {
    my $self = shift;
    
    my $tablekey = $self->{tablekey};
    my $sql = "SELECT * FROM $tablekey;";

    my ($dbh, $sth) = $self->runSqlStatement($sql);
    
    my $modelclass = $self->{modelclass};
    # require $modelclass;

    my @users;
    while(my $data = $sth->fetchrow_hashref) {
        my $model = $self->{modelclass}->new($data);
        push (@users, $model);
    }

    return \@users; 
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
1;
