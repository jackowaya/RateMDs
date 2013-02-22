#!/usr/bin/perl

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
for ($i = 1; $i <= 845; $i++) {
    $filename = "VA/VAHealthSearch/results" . threeDigit($i) . ".htm";
    open(FO, ">" . $filename) or die "Cannot open file $filename";

    my $myUrl = "http://www.vahealthprovider.com/search_results.asp?whichpage=$i&last_Name=&county=All&specialty=Any&submit=Search";

    my $content = get($myUrl);

    print FO $content;

    print "Wrote $myUrl to $filename\n";
    
    close(FO);
    sleep 30;
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



n
