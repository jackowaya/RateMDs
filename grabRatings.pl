#!/usr/bin/perl -w

# Example code from Chapter 1 of /Perl and LWP/ by Sean M. Burke
# http://www.oreilly.com/catalog/perllwp/
# sburke@cpan.org

#require 5;
use strict;
#use warnings;

use LWP::Simple;
my $myURL;
my $filename;

if (scalar(@ARGV) != 1) {
    print "Usage: grabRatings.pl StateFolder\n";
    exit;
}

my $stateFolder = $ARGV[0];
my $cnt = 0;
#my @searchPages = glob('$stateFolder/ratings/search*');

my @searchPages;
opendir(DIR, "$stateFolder/ratings");
foreach my $file (readdir(DIR)) {
    push(@searchPages, "$stateFolder/ratings/$file") if $file =~ m/search.*htm/i;
}
closedir(DIR);

foreach $filename (@searchPages) {
    open(FI, "<" . $filename) or die "Cannot open file $filename";
    my @lines = <FI>;
    close (FI);
    
#    my $prefix;
#    if ($filename =~ m/search([^.]+)\.htm/i) {
#	$prefix = $1;
#    } else {
#	print "DISASTER could not find prefix in $filename\n";
#	exit(4);
#    }
    
    # Read all the lines from file $i, then get each license found therein.
    my $j;
    for ($j = 0; $j < scalar(@lines); $j++) {
	if ($lines[$j] =~ m/HREF="\/(doctor-ratings[^" ]*).*Click to see ratings/) {
	    
	    my $originalURL = $1;
	    my ($id, $name);
	    if ($originalURL =~ m/doctor-ratings\/(\d+)/) {
		$id = $1;
	    } else { print "DISASTER id-processing $originalURL"; exit(3); }
	    if ($originalURL =~ m/([^\/]+)$/) {
		$name = $1;
	    } else { print "DISASTER name-processing $originalURL"; exit(3); }
	    
	    my $prefix;
	    if ($name =~ m/^([A-Z])/i) {
		$prefix = $1;
		$prefix =~ tr/a-z/A-Z/;
	    } else { print "DISASTER could not find first letter of name $name from $originalURL"; exit(3); }

	    $filename = "$stateFolder/ratings/$prefix/$name$id.htm";

	    if (-e $filename) {
		print "Skipped $filename\n";
	    } else {
		open(FO, ">" . $filename) or die "Cannot open file $filename";
		
		my $myUrl = "http://www.ratemds.com/$originalURL";
		
		my $content = get($myUrl);
		
		print FO $content;
		
		print "Wrote $myUrl to $filename\n";
		close(FO);
		sleep 10;
	    }
	    $cnt++;
	}
    }
    #sleep 5;
}
print "Got or skipped $cnt ratings\n";
print "done! Ta Da \n";

__END__



