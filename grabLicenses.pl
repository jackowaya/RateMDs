#!/usr/bin/perl

# Example code from Chapter 1 of /Perl and LWP/ by Sean M. Burke
# http://www.oreilly.com/catalog/perllwp/
# sburke@cpan.org

#require 5;
use strict;
use warnings;

use LWP::Simple;

use File::Copy;

my $i;
my $myURL;
my $filename;

if (scalar(@ARGV) != 1) {
    print "Usage: grabLicenses.pl StateFolder\n";
    exit;
}

my $stateFolder = $ARGV[0];

# Build a hash of all licenses so we can move them to their new correct point
my %licenseToLoc;
for ($i = 1; $i <= 845; $i++) {
    if (-d "$stateFolder/licenses/$i") {
	my @files = glob("$stateFolder/licenses/$i/*.htm");
	for my $fname (@files) {
	    if ($fname =~ m/license(\d+)\.htm/i) {
		$licenseToLoc{$1} = $fname;
	    } else {
		print "Could not handle filename $fname\n";
		exit;
	    }
	}
    }
}

print "Already downloaded " . scalar(keys(%licenseToLoc)) . " pages\n";

for ($i = 1; $i <= 845; $i++) {
    $filename = "$stateFolder/VAHealthSearch/results" . threeDigit($i) . ".htm";
    open(FI, "<" . $filename) or die "Cannot open file $filename";
    my @lines = <FI>;
    close (FI);
    
    # Make a directory for files from this page:
    unless (-d "$stateFolder/licenses/$i") {
	mkdir "$stateFolder/licenses/$i" or die "Could not make directory $!";
	print "Created folder $stateFolder/licenses/$i\n";
    }

    # Read all the lines from file $i, then get each license found therein.
    my $j;
    for ($j = 0; $j < scalar(@lines); $j++) {
	if ($lines[$j] =~ m/license_no=(\d+)/) {
	    
	    $filename = "$stateFolder/licenses/$i/license$1.htm";

	    if (defined($licenseToLoc{$1})) {
		if ($licenseToLoc{$1} ne $filename) {
		    # Move this file to the right place
		    print "Moving $licenseToLoc{$1} to $filename\n";
		    move($licenseToLoc{$1}, $filename) or die "Could not move file $!";
		    $licenseToLoc{$1} = $filename; # Should not need to set this, but we do it just in case.
		}
		print "Skipped downloading license $1 to $filename\n";
	    } else {

		open(FO, ">" . $filename) or die "Cannot open file $filename";

		my $myUrl = "http://www.vahealthprovider.com/print_report.asp?License_no=$1";

		my $content = get($myUrl);

		print FO $content;

		print "Wrote $myUrl to $filename\n";
		close(FO);
		sleep 30;
	    }
	}
    }
}

print "done! Ta Da \n";

sub threeDigit
{
    my $num = $_[0];
    if ($num < 10) {
	return "00" . $num;
    } elsif ($num < 100) {
	return "0" . $num;
    } else {
	return $num;
    }
}

__END__



