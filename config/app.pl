#!/usr/bin/perl

use strict;
use warnings;

return {

    bootstrappers => [

        # Initialize the database.
        'Bootstrappers::Database',

        # Register the event system.
        'Bootstrappers::Events',

        # Register and boot every service.
        'Bootstrappers::Services',
        
    ],

    sessions => {

        cookie_name => 'APP_SESSION',

    },

};
