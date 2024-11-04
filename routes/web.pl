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

    Http::Route::get(
        '/profile',
        'Http::Controllers::HomeController@profile',
    )->name('profile');

    Http::Route::post(
        '/sign-out',
        'Http::Controllers::UserController@logout',
    )->name('logout');

});

1;
