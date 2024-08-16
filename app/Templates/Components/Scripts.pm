package Templates::Components::Scripts;

use parent qw(
    Foundation::Component
);

use strict;
use warnings;

use Foundation::Appify;

sub render {
    my $self = shift;

    my @scripts;

    foreach my $file (@{app()->stack('scripts')}) {
        my $content = -f $file
            ? '<script>' . app()->read($file) . '</script>'
            : $file;
        push @scripts, {
            script => $content,
        };
    }

    return $self->template('components.scripts', {
        scripts => \@scripts,
    });
}

1;
