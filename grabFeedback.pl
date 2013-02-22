#!/usr/bin/perl -w

# Example code from Chapter 1 of /Perl and LWP/ by Sean M. Burke
# http://www.oreilly.com/catalog/perllwp/
# sburke@cpan.org

#require 5;
use strict;
use warnings;

if (scalar(@ARGV) != 1) {
    print "Usage: grabFeedback.pl StateFolder\n";
    exit;
}

my $stateFolder = $ARGV[0];

use LWP::Simple;
my $i;
my $myURL;
my $filename;
my $foldername;

for ($i = 'A'; $i ne 'AA'; $i++) {
        
    $foldername = "$stateFolder/ratings/$i";

    # Read all files in folder.
    opendir(DIR, $foldername);
    my @files = grep(/\.htm$/,readdir(DIR));
    closedir(DIR);
    
    foreach $filename (@files) {
	#print "Checking file $foldername/$filename\n";
	open(INPUT, "<$foldername/$filename");
	my @lines = <INPUT>;
	close(INPUT);
	# Read all the lines from file $filename, then get each feedback found therein.
	my $j;
	for ($j = 0; $j < scalar(@lines); $j++) {
	    if ($lines[$j] =~ m/href="\/(social[^" ]*).*Read this rating's feedback/) {
		
		my $originalURL = $1;
		my $id;
		if ($originalURL =~ m/social\/\?q=node\/(\d+)/) {
		    $id = $1;
		} else { print "DISASTER id-processing $originalURL"; exit(3); }

		my $outfilename = "$stateFolder/ratings/feedback/feedback$id.htm";

		if (-e $outfilename) {
		    print "Skipped $outfilename\n";
		} else {
		    open(FO, ">" . $outfilename) or die "Cannot open file $outfilename";
		    
		    my $myUrl = "http://www.ratemds.com/$originalURL";
		    
		    my $content = get($myUrl);
		    
		    print FO $content;
		    
		    print "Wrote $myUrl to $outfilename\n";
		    close(FO);
		    sleep 10;
		}
	    }
	}
    }
    #sleep 5;
}

print "done! Ta Da \n";

__END__



