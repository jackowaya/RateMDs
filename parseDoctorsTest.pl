#!/usr/bin/perl -w

use strict;
use warnings;

if (scalar(@ARGV) != 1) {
    print "Usage: parseDoctors.pl StateFolder\n";
    exit;
}

my $stateFolder = $ARGV[0];

my $i;
our $filename;
open(OUTFILE, ">$stateFolder/data/doctorGeneralInfo.txt") or die "Could not open output file $!";
print OUTFILE "Serial #\tLast name\tFirst name\tSex\tSpecialty\tCity\tLast rated\t# of ratings\tOverall Quality\tURL to detailed ratings\n";

my $totalCnt = 1;
# For i in [A-Z]
for ($i = 'A'; $i ne 'AA'; $i++) {
#for ($i = 'Y'; $i ne 'Z'; $i++) {
    my $done = 0;
    for (my $num = 0; !$done; $num++) {
	#figure out which file to open.
	$filename = "$stateFolder/ratings/search$i$num.htm";
	my @lines;
	if (-e $filename) {
	    open(INPUT, "<$filename") or die "Could not open input file $filename $!";
	    @lines = <INPUT>;
	    close(INPUT);
	} else {
	    # Finish this, there are no more pages for this letter.
	    print "Finished with letter $i as there are no more pages.\n";
	    $done = 1;
	    next;
	}

	print "Opened file $filename\n";
	
	my $j;
	for ($j = 0; $j < scalar(@lines) && !$done; $j++) {
	    if ($lines[$j] =~ m/^\s*\<tr/) {
		# We MAY have an entry of interest here... let's check.
		$j += 9;
		if ($lines[$j] =~ m/HREF="\/(doctor-ratings[^" ]*).*Click to see ratings.*\>(\w+),?\s?([^<]*)\</) {
		    # We DO care about this next section!
		    # the variables we will fill in.
		    my ($lastName, $firstName, $sex, $specialty, $city, $lastRated, $numRatings, $overallQuality, $url);
		    $url = "http://www.ratemds.com/$1";
		    $lastName = $2;
		    $firstName = $3;
		    
		    my $lastNameStart = substr($lastName, 0, 1);
		    $lastNameStart =~ tr/[a-z]/[A-Z]/; # Fix lowercase doctors.
		    if ($lastNameStart ne $i) { #Check if we are finished because we have passed the letter.
			print "Finished with letter $i as we found doctor $lastName\n";
			$done = 1;
			next;
		    }

		    $j += 3;
		    if ($lines[$j] =~ m/(M|F?)&nbsp;/) {
			$sex = $1;
		    } else { generateError("Cannot find sex in $lines[$j] for doctor $lastName"); }
		    
		    $j += 3;
		    if ($lines[$j] =~ m/specialty.*white"\>([^<]*)/) {
			$specialty = $1;
		    } else { generateError("Could not find specialty in $lines[$j] for doctor $lastName"); }
		    
		    $j += 3;
		    if ($lines[$j] =~ m/city.*white"\>([^<]*)/) {
			$city = $1;
		    } else { generateError("Could not find city in $lines[$j] for doctor $lastName"); }
		    
		    $j += 4;
		    if ($lines[$j] =~ m/(\d+\/\d+\/\d+)/) {
			$lastRated = $1;
		    } else { generateError("Could not find last rated in $lines[$j] for doctor $lastName"); }
		    
		    
		    $j += 5;
		    if ($lines[$j] =~ m/white"\>(\d+)\</) {
			$numRatings = $1;
		    } else { generateError("Could not find number of ratings in $lines[$j] for doctor $lastName"); }
		    
		    $j += 3;
		    if ($lines[$j] =~ m/^\s*(\d\.\d)\s*$/) {
			$overallQuality = $1;
		    } else { generateError("Could not find overall quality in $lines[$j] for doctor $lastName"); }
		    
		    print OUTFILE tabSeparate("$stateFolder-$totalCnt", $lastName, $firstName, $sex, $specialty, $city, $lastRated, $numRatings, $overallQuality, $url);
		    $totalCnt++;
		} 
	    }
	}   
    }
}

close (OUTFILE);

sub generateError
{
    print "Error in processing $filename: $_[0]\n";
    close(OUTFILE);
    exit(3);
}

# Generate clean tab separated output, without tabs inside of elements.
sub tabSeparate
{
    my $i;
    my $output = "";
    my $tmp;
    for ($i = 0; $i < scalar(@_) - 1; $i++) {
	$tmp = $_[$i];
	if (!defined($tmp)) { generateError("Got undefined value $output !"); }
	$tmp =~ s/\s+/ /g;
	$output = $output . $tmp . "\t";
    }
    $tmp = $_[$i];
    $tmp =~ s/\s+/ /g;
    $output = $output . $tmp . "\n";
    
    return $output;
}
