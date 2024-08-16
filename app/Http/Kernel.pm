package Http::Kernel;

use strict;
use warnings;
use Http::Response;
use Http::Router;

sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub handle {
    my $self = shift;
    my $request = shift;

    return &_::app()->make(
        'Foundation::Pipeline',
    )->send(
        $request,
    )->through([

        # The session must be present asap in case errors occur like we were
        # unable to find a route. This way we can ensure that the visitor is
        # already signed in and therefore the html layout presents itself like
        # it should.
        'Http::Middlewares::EnsureStatefulSession',
        
        'Http::Middlewares::FlashMessages',

    ])->then(sub {
        my $router = &_::app()->singleton('Http::Router')->boot();

        my $path = $ENV{REQUEST_METHOD};
        $path .= $ENV{PATH_INFO} || '/';

        my $route = $router->find($path);

        unless ($route) {
            &_::abort('Unable to find: ' . $request->request_uri, 404)
        }

        $request->append(
            
            # Ensure that the name is very unlikely do be picked.
            -name => '__route__',

            # The CGI package does not allow to append hash_refs but unpacks
            # array_refs with only one item by default. Therefore we can simply
            # pass an array_ref including the hash_ref.
            -values => [$route],

        );

        return $router->dispatch($route, $request);
    });
}

1;
