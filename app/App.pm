package App;

use strict;
use warnings;

use Data::Dumper;
use Digest::SHA;
use HTML::Template;
use JSON;
use Foundation::Appify;
use Foundation::Traits::HasMacros;

sub new {
    my $class = shift;
    my $basePath = shift;

    my $self = {
        log_file => '/app.log',
        base_path => $basePath,
        dbh => undef,
        session => undef,
        instances => {},
        config => {},
        macros => {},
        stacks => {},
        permissions => ()
    };
    bless $self, $class;

    return $self;
}

sub registerServicePermissions {
    my $self = shift;
    my $permissions = shift;

    push (@ {$self->{permissions}}, @$permissions);
}

sub bootstrap {
    my $self = shift;

    my $bootstrappers = $self->config('app.bootstrappers', []);
    foreach my $bootstrapper (@{$bootstrappers}) {
        my $instance = $self->make($bootstrapper);
        $instance->bootstrap($self);
    }

    use Data::Dumper;
    die Dumper($self->{permissions});
}

sub config {
    my $self = shift;
    my $key = shift;
    my $default = shift;

    my $prefix = undef;

    my @namespaceParts = split('::', $key);
    if (scalar @namespaceParts > 1) {
        $prefix = shift @namespaceParts;
        $key = join('::', @namespaceParts);
    }

    my @parts = split '\.', $key;
    
    my $filename = shift @parts;

    my $config = $self->readConfig($filename, $prefix);

    return $self->traverseHash($config, join('.', @parts), $default);
}

sub readConfig {
    my $self = shift;
    my $name = shift;
    my $prefix = shift;

    my $prefixKey = $prefix ? "$prefix." : '';

    if ($self->{config}->{$prefixKey . $name}) {
        return $self->{config}->{$name};
    }

    my $prefixDir = $prefix ? "/services/$prefix" : '';

    my $config = require $self->basePath() . $prefixDir . '/config/' . $name . '.pl';

    $self->{config}->{$name} = $config;

    return $self->{config}->{$name};
}

sub env {
    my $self = shift;
    my $key = shift;
    my $default = shift;

    my @parts = split '\.', $key;

    my $env = $self->readJson($self->basePath() . '/env.json');

    return $self->traverseHash($env, join('.', @parts), $default);
}

sub abort {
    my $self = shift;
    my $message = shift;
    my $code = shift || 500;

    my $template = &_::template('error', {
        'code' => $code,
        'message' => $message,
    }, {
        title => $code,
    })->output();

    my $response = $self->make('Http::Response');

    $response->setStatusCode($code);
    $response->setBody($template);

    $response->send();

    exit;
}

sub dd {
    my $self = shift;

    my $data = shift;

    if (ref $data) {
        die Dumper $data;
    }
    die $data;
}

sub make {
    my $self = shift;
    my $abstract = shift;
    my @args = @_;

    if (my $instance = $self->{instances}->{$abstract}) {
        return $instance;
    }

    my $path = $abstract;

    $path =~ s/::/\//g;
    $path .= '.pm';
    $path = $self->appPath() . '/' . $path;

    require $path;

    my $instance = $abstract->new(@args);

    return $instance;
}

sub singleton {
    my $self = shift;
    my $abstract = shift;
    my @args = @_;

    my $instance = $self->make($abstract, @args);

    $self->{instances}->{$abstract} = $instance;

    return $instance;
}

sub basePath {
    return shift->{base_path};
}

sub appPath {
    return shift->basePath() . '/app';
}

sub read {
    my $self = shift;
    my $path = shift;

    unless (-f $path) {
        &_::abort("Not a file or directory: [$path]");
    }

    open(my $fh, '<', $path) or die "Unable to open [$path]: [$!]";

    my @lines;
    while (<$fh>) {
        chomp $_;
        push @lines, $_;
    }

    close($fh);

    return join "\n", @lines;
}

sub readJson {
    my $self = shift;
    my $path = shift;

    return decode_json($self->read($path));
}

sub template {
    my $self = shift;
    my $templateName = shift;
    my $substitutions = shift;
    my $layoutSubstitutions = shift || {};
    my $layoutName = shift || 'layouts.master';

    my $template = HTML::Template->new(
        filename => $self->templateNameToPath($templateName),
        vanguard_compatibility_mode => 1,
    );

    if (ref $substitutions eq 'HASH') {
        $template->param(%{$substitutions});
    }

    my $layout = HTML::Template->new(
        filename => $self->templateNameToPath($layoutName),
        vanguard_compatibility_mode => 1,
    );

    $layoutSubstitutions->{title} = $layoutSubstitutions->{headline}
        || $layoutSubstitutions->{title}
        || $self->env('app_name');

    if (
        $ENV{PATH_INFO} =~ /^\/apps\/.+$/
        || $ENV{PATH_INFO} =~ /^\/apps\/.+\//)
    {
        $layoutSubstitutions->{title}
            .= ' - ' . $self->getServiceFromPathInfo();
    }

    $layout->param(
        content => $template->output(),
        auth_user => $self->authUser(),
        %{$layoutSubstitutions},
        'stack:services' => $self->component('service-bar'),
        'stack:styles' => $self->component('styles'),
        'stack:scripts' => $self->component('scripts'),
    );

    return $layout;
}

sub getServiceFromPathInfo {
    my $self = shift;

    my @parts = split('/', $ENV{PATH_INFO});
    my $found = 0;
    foreach my $part (@parts) {
        if ($found) {
            return $part;
        }
        if ($part eq 'apps') {
            $found = 1;
        }
    }
    return;
}

sub pushToStack {
    my $self = shift;
    my $name = shift;
    my $data = shift;

    unless ($self->{stacks}->{$name}) {
        $self->{stacks}->{$name} = [];
    }

    push @{$self->{stacks}->{$name}}, $data;

    return $self;
}

sub stack {
    my $self = shift;
    my $name = shift;

    unless ($self->{stacks}->{$name}) {
        return [];
    }

    return $self->{stacks}->{$name};
}

sub component {
    my $self = shift;
    my $name = shift;

    $name = 'templates.components.' . $name;

    my @packageParts;
    foreach my $part (split('\.', $name)) {
        
        my @words;
        foreach my $word (split('-', $part)) {
            push(@words, ucfirst($word));
        }

        push(@packageParts, ucfirst(join('', @words)));

    }

    return $self->make(join('::', @packageParts))->render();
}

sub templateNameToPath {
    my $self = shift;
    my $template = shift;

    if (ref $template) {
        die "Not a string: [$template]";
    }

    my $base = $self->basePath();

    if ($template =~ /^(.+)::(.+)$/) {
        $base = $self->servicePath($1);
        $template = $2;
    }

    my $dir = $base . '/templates';

    $template =~ s/\./\//g;
    $template .= '.tmpl';

    return $dir . '/' . $template;
}

sub servicePath {
    my $self = shift;
    my $service = shift;

    my $base = $self->basePath() . '/services';
    unless ($service) {
        return $base;
    }

    return "$base/$service";
}

sub authUser {
    my $self = shift;

    my $session = $self->{session};
    unless ($session) {
        return undef;
    }
    return $session->get('user_id') || undef;
}

sub traverseHash {
    my $self = shift;
    my $haystack = shift;
    my $key = shift;
    my $default = shift;

    $default = defined $default ? $default : undef;

    my @needles = split('\.', $key);
    my $needle = shift @needles;
    $haystack = defined $haystack->{$needle} ? $haystack->{$needle} : undef;
    if (!@needles && defined $haystack) {
        return $haystack;
    }
    unless (ref $haystack eq 'HASH') {
        return $default;
    }
    return $self->traverseHash($haystack, join('.', @needles), $default);
}

sub setDatabaseHandler {
    my $self = shift;
    my $dbh = shift;

    $self->{dbh} = $dbh;
}

sub uploaddir {
    my $self = shift;

    return $self->basePath() . '/storage';
}

sub database {
    return shift->{dbh};
}

sub uuid {
    return `cat /proc/sys/kernel/random/uuid`;
}

sub setSession {
    my $self = shift;
    my $session = shift;

    $self->{session} = $session;

    return;
}

sub session {
    return shift->{session};
}

sub salt {
    my $self = shift;

    my @set = ('a'..'z','A'..'Z','0'..'9','-','_');
    my $salt = '';
    for (1..32) {
        $salt .= $set[rand @set];
    }
    
    return $salt;
}

sub hash {
    my $self = shift;
    my $content = shift;
    my $salt = shift;

    my $salt = $salt || $self->salt();
    
    return Digest::SHA->new(512)->add($content, $salt)->b64digest(), $salt;
}

sub log {
    my $self = shift;
    my @messages = @_;

    foreach my $message (@messages) {

        if (ref $message eq 'ARRAY' || ref $message eq 'HASH') {
            my $json = JSON->new()->convert_blessed;
            $message = $json->encode($message);
        }

        if (ref $message) {
            $message = Dumper $message;
        }

        my $file = $self->basePath() . $self->{log_file};

        my ($package, $source, $line) = caller(1);

        open (my $fh, '>>', $file) or die "Unable to open file [$file]: $!";

        print $fh time() . " INFO $message at $source:$line\n";

        close($fh);

    }

    return $self;
}


# Reads the service's config/app.conf file by default. Specifying the second parameter multiple files can be read individually
# 
# Example: getServiceConfig('testservice', 'user.pl') will read the file servicepath('testservice') . "/config/user.pl";
#
# If the file does not exist undef will be returned, otherwise a Hash of the config keys and values.
#
# A.t.P only .pl and .conf file reading is supported, any other file type will be ignored and return undef.
sub getServiceConfig {
    my $self = shift;
    my $serviceid = shift or die "Please Specify the services ID";  #example 'testservice'
    my $filename = shift || "app.conf";

    my $servicepath = $self->servicePath($serviceid);
    
    my @split = split(/\./, $filename);
    my $ending;
    unless(scalar @split > 1) {
        $ending = ".conf";
        $filename .= $ending;
    } else {
        $ending = pop(@split);
    }
    my $filepath = $servicepath . "/config/$filename";
    
    my $config = ($ending eq 'pl') ? require $filepath : {};

    if ($ending eq 'conf') {
        open(CONF, '<', $filepath) or return undef;

        while (<CONF>) {
            chomp ($.);                                     # no newline
            s/#.*//;                                        # no comments
            s/^\s+//;                                       # no leading white
            s/\s+$//;                                       # no trailing white
            next unless length;                             # anything left?
            my ($var, $value) = split(/\s*=\s*/, $_, 2);
            $config->{$var} = $value;
        }
        close(CONF);
    }
    return $config;

}

sub storageFilePath {
    my $self = shift;
    my $filename = shift;

    my $targetpath = $self->basePath() . "/storage/$filename";
    
    return $targetpath;
}

sub uploadFile {
    my $self = shift;
    my $request = shift;
    my $filename = shift;

    my $uploadfh = $request->upload('file');
    my $targetpath = $self->storageFilePath($filename);
    
    # Set right encoding
    use utf8;
    use open ':encoding(utf8)';
    open OUTFH, '>', $targetpath;
    
    my $string = '';

    while (<$uploadfh>) {
        $string .= $_;
    }

    print OUTFH $string;

    return $targetpath;

}
1;
