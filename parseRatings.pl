#!/usr/bin/perl -w

use strict;
use warnings;

if (scalar(@ARGV) != 1) {
    print "Usage: parseRatings.pl StateFolder\n";
    exit;
}

my $stateFolder = $ARGV[0];

our $filename = "$stateFolder/data/doctorGeneralInfo.txt";
open(OUTFILE, ">$stateFolder/data/doctorRatings.txt") or die "Could not open output file $stateFolder/data/doctorRatings.txt $!";
print OUTFILE "Serial #\tLast name\tFirst name\tMiddle name\tName Appendix\tSpecialty\tRatingID\tDate\tStaff\tpunctual\thelpfulness\tknowledge\tcomments\tinsurance\tregistered or not\n";

open(INPUT, "<$filename") or die "Could not open input file $filename $!";
my @inputlines = <INPUT>;
close(INPUT);

print "Starting to parse ratings\n";

my $inputline;
foreach $inputline (@inputlines) {
    my @parts = split(/\t/, $inputline);
    if ($parts[1] ne "Last name") { #Skips heading line.
	#In each line, we have to fill in all fields:
	my ($lastName, $firstName, $middleName, $nameAppendix, $specialty);
	my $serial = shift(@parts);
	$lastName = $parts[0];
	$firstName = $parts[1];
	$middleName = $parts[2];
	shift(@parts); # Fix the fact that we added middle name
	$nameAppendix = $parts[2];
	shift(@parts); # Fix the fact that we added name appendix.
	$specialty = $parts[3];
	
	# Read in the doctor's ratings file.
	my $doctorFile;
	if ($parts[8] =~ m/([^\/])([^\/]+)$/) {
	    $doctorFile = "$1/$1$2";
	    chomp $doctorFile;
	    my $doctorFirstLetter = substr($doctorFile, 0, 1);
	    if ($doctorFirstLetter =~ m/[a-z]/) { # Fix lowercase
		$doctorFirstLetter =~ tr/a-z/A-Z/;
		$doctorFile = $doctorFirstLetter . substr($doctorFile, 1);
	    }
	} else { generateError("Could not find last name in url $parts[8]"); }
	if ($parts[8] =~ m/\.com\/doctor-ratings\/(\d+)/) {
	    $doctorFile .= "$1.htm";
	} else { generateError("Could not find rating id in url $parts[8]"); }
	
	open(DFILE, "<$stateFolder/ratings/$doctorFile") or die "Could not open doctor file $stateFolder/ratings/$doctorFile $!";
	my @lines = <DFILE>;
	close(DFILE);
	
	# Get info for each rating in this file.
	my $i;
	for ($i = 0; $i < scalar(@lines); $i++) {
	    if ($lines[$i] =~ m/\<tr/) { # line MIGHT be interesting
		$i += 2;
		if ($lines[$i] =~ m/\<a name="(\d+)/) {
		    #line IS interesting.
		    my ($ratingID, $date, $staff, $punctual, $helpful, $knowledgeable, $comments, $insurance, $registered);
		    $ratingID = $1;
		    $registered = "No";
		    
		    $i += 7;
		    if ($lines[$i] =~ m/\#reg.*\*/) { $registered = "Yes"; }

		    $i += 3;
		    if ($lines[$i] =~ m/&nbsp;(\d+\/\d+\/\d+)/) {
			$date = $1;
		    } else { generateError("Docotor $lastName: Could not find date in $lines[$i]"); }

		    $i += 1;
		    if ($lines[$i] =~ m/white"\>(\d?)/) {
			$staff = $1;
		    } else { generateError("Docotor $lastName: Could not find staff in $lines[$i]"); }

		    $i += 1;
		    if ($lines[$i] =~ m/white"\>(\d?)/) {
			$punctual = $1;
		    } else { generateError("Docotor $lastName: Could not find punctual in $lines[$i]"); }

		    $i += 1;
		    if ($lines[$i] =~ m/white"\>(\d?)/) {
			$helpful = $1;
		    } else { generateError("Docotor $lastName: Could not find helpful in $lines[$i]"); }

		    $i += 1;
		    if ($lines[$i] =~ m/white"\>(\d?)&nbsp;/) {
			$knowledgeable = $1;
		    } else { generateError("Docotor $lastName: Could not find knowledgeable in $lines[$i]"); }

		    $i += 4;
		    if ($lines[$i] =~ m/\s*(\w.*)/) {
			$comments = $1;
		    } else { generateError("Docotor $lastName: Could not find comments in $lines[$i]"); }

		    $i += 1;
		    if ($lines[$i] =~ m/Insurance:\<\/b\> (.*)/) {
			$insurance = $1;
		    } else { $insurance = ""; }

		    print OUTFILE tabSeparate($serial, $lastName, $firstName, $middleName, $nameAppendix, $specialty, $ratingID, $date, $staff, $punctual, $helpful, $knowledgeable, $comments, $insurance, $registered);
		}
	    }
	}
    }
}

print "Done parsing ratings\n";

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
