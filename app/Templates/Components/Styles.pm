package Templates::Components::Styles;

use parent qw(
    Foundation::Component
);

use strict;
use warnings;
use Data::Dumper;

use Foundation::Appify;

sub render {
    my $self = shift;

    my @styles;
    foreach my $style (@{app()->stack('styles')}) {
        my $file = $style->{path};
        my $id = $style->{id};
        my $filecontent = -f $file ? app->read($file) : $file;
       
        push @styles, {
            style => $id
                ? '<style id="'.$id.'">' . $filecontent. '</style>'
                : '<style>' . $filecontent . '</style>'
        };
    }
    return $self->template('components.styles', {
        styles => \@styles,
    });
}

1;