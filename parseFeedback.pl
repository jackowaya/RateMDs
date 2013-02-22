#!/usr/bin/perl -w

use strict;
use warnings;

if (scalar(@ARGV) != 1) {
    print "Usage: parseFeedback.pl StateFolder\n";
    exit;
}

my $stateFolder = $ARGV[0];

open(OUTFILE, ">$stateFolder/data/ratingsFeedback.txt");
print OUTFILE "RatingID\tSubmitted by\tDate\tTime\tContent\n";

opendir(DIR, "$stateFolder/ratings/feedback");
my @allFiles = grep(/.htm/, readdir(DIR));
closedir(DIR);

print "Starting to parse feedback\n";

our $filename;
foreach $filename (@allFiles) {
    open(INPUT, "<$stateFolder/ratings/feedback/$filename");
    my @lines = <INPUT>;
    close(INPUT);

    my $ratingID;
    if ($filename =~ m/feedback(\d+)/) {
	$ratingID = $1;
    } else { generateError("Could not find ratingID in filename"); }

    my $i;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/Submitted by \<a[^>]+\>([^<]+)\<\/a\>[^,]+, (\d+\/\d+\/\d+) - (\d+:\d+)/) {
	    my ($submittedBy, $date, $time, $content);
	    $submittedBy = $1;
	    $date = $2;
	    $time = $3;

	    my $done = 0;
	    my $linesToCheck = 5; # Check the next 5 lines for the start of the content, then give up.
	    for (; $linesToCheck > 0 && !$done; $linesToCheck--) {
		$i += 1;
		if ($lines[$i] =~ m/content"\>(.*)/) {
		    $content = $1;
		    $done = 1;
		}
	    }
	    if (!$done) {
		generateError("Could not find content in lines preceeding $lines[$i]\n");
	    }
	    while ($lines[$i] !~ m/^\s*\<\/div\>\s*$/) { 
		$content .= $lines[$i];
		$i++;
	    }
	    $i++;
	    print OUTFILE tabSeparate($ratingID, $submittedBy, $date, $time, $content);
	}
    }
}

print "Done parsing feedback\n";

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

sub generateError
{
    print "Error in processing $filename: $_[0]";
    close(OUTFILE);
    exit(3);
}
