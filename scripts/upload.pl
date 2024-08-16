use strict;
use warnings;
use CGI;
use CGI::Carp 'fatalsToBrowser';
use Data::Dumper;

my $request = CGI->new();

my $filename = $request->param("libraryfile");
my $upload_filehandle = $request->upload("libraryfile");

# die "$uploaddir/library.xml";

open FH, ">", "/web/storage/library.xml" or die $!;

print FH $upload_filehandle;

close UPLOADFILE;