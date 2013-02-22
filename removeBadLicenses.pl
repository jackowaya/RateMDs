#!/usr/bin/perl -w

# Example code from Chapter 1 of /Perl and LWP/ by Sean M. Burke
# http://www.oreilly.com/catalog/perllwp/
# sburke@cpan.org

#require 5;
use strict;
use warnings;
use File::Copy;

if (scalar(@ARGV) != 1) {
    print "Usage: removeBadLicenses.pl StateFolder\n";
    exit;
}
my $stateFolder = $ARGV[0];

my $i;
my $file;
our $fullFilename;
my $totalNum = 845;
for ($i = 1; $i <= $totalNum; $i++) {
    my @files;
    my $directory = "$stateFolder/licenses/$i";
    opendir(DIR, $directory) or die "Could not open directory $directory $!";
    @files = grep(/.htm$/, readdir(DIR));
    closedir(DIR);

    print "Handling folder licenses/$i\n";

    my %validFiles;
    my $inFile = "$stateFolder/VAHealthSearch/results" . threeDigit($i) . ".htm"; 
    open(IN, "<$inFile") or die "Could not open search page $inFile $!";
    my @lines = <IN>;
    close(IN);

    # Read all the lines from file $i, then get each license found therein.
    my $j;
    for ($j = 0; $j < scalar(@lines); $j++) {
	if ($lines[$j] =~ m/license_no=(\d+)/) {
	    
	    my $filename = "license$1.htm";
	    $validFiles{$filename} = 1;
	}
    }


    foreach $file (@files) {
	if (!defined($validFiles{$file})) {
	    move($directory . "/" . $file, "$stateFolder/licenses/NowMissing/$file");
	    print "Removed $directory/$file\n";
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
