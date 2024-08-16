#!/usr/bin/perl

use strict;
use warnings;

use Http::Route;

Http::Route::json(&_::app()->basePath() . '/storage/web.json');

Http::Route::group({
    middlewares => [
        # 'Http::Middlewares::Auth',
    ],
}, sub {

    # logged in routes

    Http::Route::group({
        prefix => '/admin',
        as => 'admin.', 
        middlewares => [
            'Http::Middlewares::Admin',
        ],
    }, sub {
        
        # logged in as admin routes

        Http::Route::get('/', sub {
            my $request = shift;

            return &_::template('admin.dashboard', {
                'name' => 'Test',
                'company' => 'Testcompany',
            })->output();
        })

    });

    Http::Route::get(
        '/profile',
        'Http::Controllers::HomeController@profile',
    )->name('profile');

    Http::Route::post(
        '/sign-out',
        'Http::Controllers::UserController@logout',
    )->name('logout');

});

# Http::Route::get('/foo', sub {

#     my $request = shift;

#     return &_::template('register', {
#         'email_label' => 'Email',
#         'password_label' => 'Password',
#         'submit' => 'Registrieren FOO',
#     })->output();

# });

# Http::Route::group({'middlewares' => [], 'as' => 'nice.'}, sub {

#     Http::Route::get('/bar', 'Http::Controllers::HomeController@bar')
#         # ->middleware('testtest')
#         # ->middleware('abc')
#         ->name('bar');

#     Http::Route::group({'prefix' => '/test', 'as' => 'hellooo.'}, sub {

#         Http::Route::get('/foo-bar', 'Http::Controllers::HomeController@fooBar')
#             # ->middleware('testtest')
#             ->name('foo.bar');

#     });

# });

1;
