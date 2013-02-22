#!/usr/bin/perl -w

# Example code from Chapter 1 of /Perl and LWP/ by Sean M. Burke
# http://www.oreilly.com/catalog/perllwp/
# sburke@cpan.org

#require 5;
use strict;
#use warnings;

use LWP::Simple;
my $i;
my $myURL;
my $filename;

if (scalar(@ARGV) != 2) {
    print "Usage: grabSearchRatings.pl StateNumber StateInitials\n";
    print "\tGet State Number by sid in url, i.e. http://www.ratemds.com/social/?q=node/28882&sid=20 would be 20\n";
    exit;
}

my $stateNumber = $ARGV[0];
my $stateFolder = $ARGV[1];

for ($i = 'A'; $i le 'Z' && $i ne 'AA'; $i++) {
    my $cnt = 0;

    my $done = 0;
    $myURL = "http://www.ratemds.com/social/?q=node/28882&sid=$stateNumber&searchBy=DLName&letter=$i";
    until ($done) {

	$filename = "$stateFolder/ratings/search$i$cnt.htm";
    
	# Make a directory for files from this page:
	if (!(-d "$stateFolder/ratings/$i")) {
	    mkdir "$stateFolder/ratings/$i" or die "Could not make directory $stateFolder/ratings/$i $!";
	    print "Created folder $stateFolder/ratings/$i\n";
	}
    
	open(FO, ">" . $filename) or die "Cannot open file $filename $!";
		
	my $content = get($myURL);
		
	print FO $content;
		
	print "Wrote $myURL to $filename\n";
	close(FO);

	if ($content =~ m/\>\>\> More [A-Z]'s here \<\<\</is) {
	    # MIGHT have another page. We need to verify that we are not going on to the next letter.
	    if ($content =~ m/Showing \d+ docs \(.*? - ([^)]+)\)/) {
		my $lname = $1;
		if ($i eq substr($lname, 0, 1)) {
		    if ($content =~ m/href="([^"]+)"\>\<[^>]*\>\>\>\> More [A-Z]'s here/i) {
			$myURL = "http://www.ratemds.com$1";
			$cnt++;
		    } else {
			die "ERROR IN FILE $filename: Found more pages but could not find URL";
		    }
		} else {
		    # This page goes past the letter we want.
		    $done = 1; 
		}
	    } else {
		die "ERROR IN FILE $filename: Found more letters but could not find doctors";
	    }
	   
	} else {
	    $done = 1;
	}

	sleep 10;
    }
}

print "done! Ta Da \n";

__END__



