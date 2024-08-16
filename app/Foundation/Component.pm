package Foundation::Component;

use strict;
use warnings;

use HTML::Template;
use Foundation::Appify;

sub new {
    my $class = shift;
    my $basePath = shift;

    my $self = {
 
    };
    bless $self, $class;

    return $self;
}

sub template {
    my $self = shift;
    my $template = shift;
    my $substitutions = shift || {};
    my $options = shift || {};

    unless ($template) {
        die 'No template given.';
    }

    if (ref $template) {
        die "Not a string: [$template]";
    }

    $options->{filename} = defined $options->{filename}
        ? $options->{filename}
        : &_::app()->templateNameToPath($template);
    
    $options->{vanguard_compatibility_mode} = defined $options->{vanguard_compatibility_mode}
        ? $options->{vanguard_compatibility_mode}
        : 1;

    my $template = HTML::Template->new(%{$options});

    $template->param(%{$substitutions});
    
    return $template->output();

}

1;
