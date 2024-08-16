#!/usr/bin/perl

use strict;
use warnings;

use Cwd;
my $dir = cwd;
use Data::Dumper;
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
use File::Find;
use File::Path qw (make_path rmtree);

###### Get Service Name
my $servicename;
if (scalar @ARGV == 0) {
    print "Please specify the name for your service!\n";
    print "Service Name: ";
    $servicename = <>;
} else {
    $servicename = $ARGV[0];
}
chomp($servicename);
print "Service id:   " . lc($servicename) . "\n";
print "Service Name: " . ucfirst($servicename) . "\n";
###### Copy Template to new services Directory
my $source_dir = $dir . "/servicetemplate";
my $target_dir = $dir . "/services/" . lc($servicename);
my $buffer_dir = $target_dir . "buffer";
print "Source Directory: $source_dir\n";
print "Target Directory: $target_dir\n";
print "Buffer Directory: $buffer_dir\n";

mkdir($target_dir) or die "Service with that name already exists. Please run again using a different name!";
print "Successfully created Target Directory.\n";
mkdir($buffer_dir) or die "Servicebuffer with that name already exists, probably due to a faulty previous installation. Be sure to delete services/" . lc($servicename) . "buffer directory for this process to work.";
print "Successfully created Buffer Directory.\n";

dircopy($source_dir, $buffer_dir) or die $!;
print "Successfully copied Service Template into Buffer Directory.\n";

##### Collect a list of all File paths that need to be copied
my @filenames  = ();
sub remember_file {
    push(@filenames, $File::Find::name);
}
find(\&remember_file, $buffer_dir);
print scalar (@filenames) . " Files and/or Directories detected.\n";

##### Copy the files with filled in placeholders and create necessary directories
foreach my $path (@filenames) {
    my @splitname = split(/\//, $path);
    my $last = $splitname[$#splitname];
    if (index($last, '.') == -1) {
        # is a directory path, ignore
        print "$path is a directory and is being ignored.\n";
    } else {
        # is a file, process
        print "$path is a file and needs to be processed.\n";
        open my $fh, '<', $path or die $!;
        my $content = "";
        while (<$fh>) {
            $content .= $_;
        }
        close($fh);
        my $lowercasename = lc($servicename);
        my $uppercasename = ucfirst($servicename);
        # Replace Placeholders in paths and directories with services name
        $path =~ s/SERVICENAMEPLACEHOLDER/$uppercasename/g;
        $path =~ s/servicenameplaceholder/$lowercasename/g;
        $content =~ s/SERVICENAMEPLACEHOLDER/$uppercasename/g;
        $content =~ s/servicenameplaceholder/$lowercasename/g;
        # Create buffer-less directories for the actual service files
        my $buffername = $lowercasename . "buffer";
        my $targetpath = $path;
        $targetpath =~ s/buffer//;
        # die $targetpath;
        my @dirpath = split( /\//, $targetpath);
        pop(@dirpath);
        my $dir = join('/', @dirpath);
        make_path($dir);
        open(NFH, '>', $targetpath) or die $targetpath . ":::" . $dir;
        print NFH $content;
        close(NFH);
        print "Successfully processed $path\n";
    }
}
print "Successfully processed all files. Removing buffer directory.\n";
#Remove the obsolete buffer directory
rmtree($buffer_dir);
print "Successfully removed buffer directory. Process is finished.\n";
exit();