package Http::Middlewares::FlashMessages;

use strict;
use warnings;

use Foundation::Appify;
use JSON;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub handle {
    my $self = shift;
    my $request = shift;
    my $next = shift;
    my $args = shift;

    my $response = &$next($request);

    if ($response->{redirect}) {
        return $response;
    }

    my $content = eval { decode_json(session()->get('content')) };

    unless ($content || $content->{messages}) {
        return $response;
    }

    my $html = '';
    foreach my $message (@{$content->{messages}}) {
        $html .= "<input type='hidden' class='flashable' value='$message' >"
    }

    $response->{body} =~ s/\<\!-- \[FLASH_MESSAGE_CONTAINER\] --\>/$html/g;

    session()->forget('messages');

    return $response;
}

1;
