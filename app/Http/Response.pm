package Http::Response;

use strict;
use warnings;

use JSON;
use Foundation::Appify;

sub new {
    my $class = shift;

    my $self = {
        content_type => 'text/html',
        charset => 'utf-8',
        status_code => 200,
        body => undef,
        cookies => {},
        redirect => undef,
    };
    bless $self, $class;

    return $self;
}

sub setContentType {
    my $self = shift;
    my $contentType = shift;

    $self->{content_type} = $contentType;
}

sub setCharset {
    my $self = shift;
    my $charset = shift;

    $self->{charset} = $charset;
}

sub setStatusCode {
    my $self = shift;
    my $statusCode = shift;

    $self->{status_code} = $statusCode;
}

sub setBody {
    my $self = shift;
    my $body = shift;

    $self->{body} = $body;
}

sub setCookie {
    my $self = shift;
    my $name = shift;
    my $value = shift;
    my $options = shift;

    $self->{cookies}->{$name} = {
        -value => $value,
        %{$options},
    };
}

sub send {
    my $self = shift;

    my $cgi = CGI->new();

    if ($self->{redirect}) {
        return print $cgi->redirect(
            -uri => &_::env('url', '') . $self->{redirect}->{to},
            -status => $self->{redirect}->{status},
        );
    }

    my @cookies;
    foreach my $name (keys %{$self->{cookies}}) {
        my $cookie = $self->{cookies}->{$name};
        my $test = $cgi->cookie(
            -name => $name,
            %{$cookie},
        );
        push(@cookies, $test);
    }

    print $cgi->header(
        -type => $self->{content_type},
        -charset => $self->{charset},
        -status => $self->{status_code},
        -cookie => \@cookies,
    );

    return print $self->{body};
}

sub redirect {
    my $self = shift;
    my $to = shift;
    my $messages = shift || [];
    my $status = shift;

    $self->{redirect} = {
        to => $to,
        status => $status,
    };

    session()->remember('messages', $messages);

    return $self;
}

1;
