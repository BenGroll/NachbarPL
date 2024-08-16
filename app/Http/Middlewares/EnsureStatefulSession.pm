package Http::Middlewares::EnsureStatefulSession;

use strict;
use warnings;
use Models::Session;

sub new {
    my $class = shift;

    my $self = {
        cookie_name => &_::app()->config('app.sessions.cookie_name', 'session'),
    };
    bless $self, $class;

    return $self;
}

sub handle {
    my $self = shift;
    my $request = shift;
    my $next = shift;

    my $session = Models::Session::retrieve(
        $request->cookie($self->{cookie_name}),
    );

    my $cookie = 0;

    unless ($session) {
        my $token = &_::app()->uuid();
        $token =~ s/-//g;

        chomp $token;

        $session = Models::Session->new({
            token => $token,
        })->save();

        $cookie = 1;   
    }

    &_::app()->setSession($session);
    
    my $response = &$next($request);

    if ($cookie) {
        $response->setCookie($self->{cookie_name}, $session->get('token'), {
            -expires => '+3d',
        });
    }

    return $response;
}

1;
