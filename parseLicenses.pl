#!/usr/bin/perl -w

# Example code from Chapter 1 of /Perl and LWP/ by Sean M. Burke
# http://www.oreilly.com/catalog/perllwp/
# sburke@cpan.org

#require 5;
use strict;
use warnings;
use File::Copy;

if (scalar(@ARGV) != 1) {
    print "Usage: parseLicenses.pl StateFolder\n";
    exit;
}
my $stateFolder = $ARGV[0];

my $dataFolder = "datatest";

our $doAll = 0; # do everything.
our $doBoardCert = 0;
our $doOtherActions = 0;
our $doAcademicAppoint = 0;
our $doOtherHospitals = 0;
our $doPaidClaims = 0;
our $doPostGrad = 0;
our $doPracticeOffices = 1;
our $doDoctorInfo = 1; # We ALWAYS do doctor info.

#Open all output files
if ($doAll || $doPracticeOffices) {
open(PRACTICEOFFICES, ">$stateFolder/$dataFolder/PracticeOffices.txt") or die "Could not open output file $!";
}
if ($doAll) {
open(NONENGLISHOFFICES, ">$stateFolder/$dataFolder/NonEnglishOffices.txt") or die "Could not open output file $!";
open(NONENGLISHPRACTITIONER, ">$stateFolder/$dataFolder/NonEnglishPractitioner.txt") or die "Could not open output file $!";
open(VAHOSPITALS, ">$stateFolder/$dataFolder/VAHospitals.txt") or die "Could not open output file $!";
}
if ($doAll || $doOtherHospitals) {
open(OTHERHOSPITALS, ">$stateFolder/$dataFolder/OtherHospitals.txt") or die "Could not open output file $!";
}
if ($doAll) {
open(GRADSCHOOL, ">$stateFolder/$dataFolder/GradSchool.txt") or die "Could not open output file $!";
}
if ($doAll || $doPostGrad) {
open(POSTGRADSCHOOL, ">$stateFolder/$dataFolder/PostGradSchool.txt") or die "Could not open output file $!";
}
if ($doAll) {
open(CONTINUINGED, ">$stateFolder/$dataFolder/ContinuingEd.txt") or die "Could not open output file $!";
}
if ($doAll || $doBoardCert) {
open(BOARDCERT, ">$stateFolder/$dataFolder/BoardCertification.txt") or die "Could not open output file $!";
}
if ($doAll) {
open(PRACTICEAREAS, ">$stateFolder/$dataFolder/PracticeAreas.txt") or die "Could not open output file $!";
open(INSURANCEPLANS, ">$stateFolder/$dataFolder/InsurancePlans.txt") or die "Could not open output file $!";
open(HONORS, ">$stateFolder/$dataFolder/HonorsAndAwards.txt") or die "Could not open output file $!";
}
if ($doAll || $doAcademicAppoint) {
open(ACADEMIA, ">$stateFolder/$dataFolder/AcademicAppointments.txt") or die "Could not open output file $!";
}
if ($doAll) {
open(PUBLICATIONS, ">$stateFolder/$dataFolder/Publications.txt") or die "Could not open output file $!";
open(FELONY, ">$stateFolder/$dataFolder/Felonies.txt") or die "Could not open output file $!";
}
if ($doAll || $doOtherActions) {
open(ACTIONSBYOTHERS, ">$stateFolder/$dataFolder/ActionsByOthers.txt") or die "Could not open output file $!";
}
if ($doAll) {
open(VAORDERSNOTICES, ">$stateFolder/$dataFolder/VAOrdersAndNotices.txt") or die "Could not open output file $!";
}
if ($doAll || $doPaidClaims) {
open(PAIDCLAIMS, ">$stateFolder/$dataFolder/PaidClaims.txt") or die "Could not open output file $!";
}
open(DOCTORINFO, ">$stateFolder/$dataFolder/DoctorInfo.txt") or die "Could not open output file $!";

#Write output headers.
if ($doAll || $doPracticeOffices) {
print PRACTICEOFFICES "License #\tPractice Name\tOffice Type\tStreet\tCity\tState\tZip\tSub-zip\tPhone\tLast Updated\tLocation Details-time spent\tDays\tTranslation services\tType(s) of Translation Services Available\n";
}
if ($doAll) {
print NONENGLISHOFFICES "License #\tOffice type\tNon-English language(s) spoken in office\n";
print NONENGLISHPRACTITIONER "License #\tOffice type\tNon-English language(s) spoken by practitioner\n";
print VAHOSPITALS "License #\tVirginia Hospital Affiliations - last update\tVirginia Hospital Affiliations\n";
}
if ($doAll || $doOtherHospitals) {
print OTHERHOSPITALS "License #\tout of Virginia Hospital Affiliations - last update\tout of VA hospital Affiliation\n";
}
if ($doAll) {
print GRADSCHOOL "License #\tMedical, Osteopathic, or Podiatric School - last update\tGrad School Name\tCity\tState\tCountry\tYear completed- Grad school\n";
}
if ($doAll || $doPostGrad) {
print POSTGRADSCHOOL "License #\tPost Grad School - last update\tSpecialty\tPost Grad School Name\tCity\tState\tCountry\tStage\tYear Completed Post Grad\n";
}
if ($doAll) {
print CONTINUINGED "License #\tContinuing Education - last update\tContinuing Hours\tSince year -continuing eduction\n";
} 
if ($doAll || $doBoardCert) {
print BOARDCERT "License #\tBoard Certification - last update\tBoard Certification - specialty\tYear of Initial Certifications\tCurrent Certification Expires\n";
}
if ($doAll) {
print PRACTICEAREAS "License #\tSelf-Designated practive Areas Last-update\tPractice Area\n";
print INSURANCEPLANS "License #\tInsurance Plans/Managed Care Plans Accepted - last update\tInsurance\tRole-insurance\n";
print HONORS "License #\tHonors and Awards - last update\tHonor name\tHonor institute\tHonor year\n";
}
if ($doAll || $doAcademicAppoint) {
print ACADEMIA "License #\tAcademic Appointments - last update\tUniversity\trank\tAcademic Year start\tAcademic year end\tUS or not\n";
}
if ($doAll) {
print PUBLICATIONS "License #\tPublications - last update\tTitle\tJounal\tIssue\tDate of publication\tJournal Website\n";
print FELONY "License #\tFelony Conviction - last update\tFelony Conviction Information\n";
}
if ($doAll || $doOtherActions) {
print ACTIONSBYOTHERS "License #\tActions outside VA - Last update\tEntity Taking Action\tAction Taken\tDate\n";
}
if ($doAll) {
print VAORDERSNOTICES "License #\tNoticeURL\n";
}
if ($doAll || $doPaidClaims) {
print PAIDCLAIMS "License #\tPaid claims - last update\tSpecialty\tLocation\tYear\tAmount of claim\tPractitioner Comments\t# of practitioners with same specialty\tPercentage\n";
}
print DOCTORINFO "License #\tLast Name\tFirst Name\tMiddle Name\tSuffix\tEmail\tWebsite\tIssue Date\tExpiration Date\tStatus\tYears in Practice Last Updated\tYears In US/Canada\tYears Out of US/Canada\tMedicated Last Updated\tParticipate in Medicaid\tAccept new Medicaid\tMedicare Last Updated\tMedicare\n";

my $i;
my $file;
our $fullFilename;
my $totalNum = 845;
# First, build a hash of all license numbers to an array ref containing (last name, first name, middle name)
our %nameHash;
for ($i = 1; $i <= $totalNum; $i++) {
#for ($i = 384; $i <= 384; $i++) {
    my $file = "$stateFolder/VAHealthSearch/results" . threeDigit($i) . ".htm";
    open(IN, "<$file") or die "Cannot open $file $!";
    my @lines = <IN>;
    close(IN);
    foreach my $line (@lines) {
	if ($line =~ m/href=results_generalinfo.asp\?license_no=(\d+)\>([^<]+)/) {
	    my $licenseNo = $1;
	    my $name = $2;
	    my ($first, $last, $mid);
	    if ($name =~ m/([^,]+), (\S*) ?(.*)/) {
		$last = $1;
		$first = $2;
		$mid = $3;
	    } else {
		$last = $name;
		$first = "";
		$mid = "";
	    }
	    my @nameArr = ($last, $first, $mid);
	    $nameHash{$licenseNo} = \@nameArr;
	}
    }
}

for ($i = 1; $i <= $totalNum; $i++) {
#for ($i = 384; $i <= 384; $i++) {
    my @files;
    my $directory = "$stateFolder/licenses/$i";
    opendir(DIR, $directory);
    @files = grep(/.htm$/, readdir(DIR));
    closedir(DIR);

    print "Handling folder licenses/$i\n";

    foreach $file (@files) {
	parseFile("$stateFolder/licenses/$i/$file");
    }
}

closeAll();
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


sub parseFile
{
    my $filename = $_[0];
    $fullFilename = $filename;
    print "Opened $filename\n";
    open(INPUTFILE, "<$filename") or die "Could not open $filename: $!";
    my @lines = <INPUTFILE>;
    close(INPUTFILE);

    # Delay processing of files with too few lines (i.e. no newlines).
    if (scalar(@lines) < 5) {
	if ($filename =~ m/(license\d+.htm)/) {
	    move($filename, "licenses/999/$1");
	    generateAlert("moved $filename to licenses/999/$1");
	} else {
	    generateError("Found file with too few lines but could not move it $!");
	}
	return;
    }

    my $isExpired = parseDoctorInfo(@lines);
    if (!$isExpired) {
	if ($doAll || $doPracticeOffices) {
	parsePracticeOffices(@lines);
	}
	if ($doAll) {
	parseNonEnglishLanguages(@lines);
	parseVAHospitals(@lines);
	}
	if ($doAll || $doOtherHospitals) {
	parseOtherHospitals(@lines);
	}
	if ($doAll) {
	parseGradSchool(@lines);
	}
	if ($doAll || $doPostGrad) {
	parsePostGradSchool(@lines);
	}
	if ($doAll) {
	parseContinuingEd(@lines);
	}
	if ($doAll || $doBoardCert) {
	parseBoardCert(@lines);
	}
	if ($doAll) {
	parsePracticeAreas(@lines);
	parseInsurancePlans(@lines);
	parseHonors(@lines);
	}
	if ($doAll || $doAcademicAppoint) {
	parseAcademia(@lines);
	}
	if ($doAll) {
	parsePublications(@lines);
	parseFelony(@lines);
	}
	if ($doAll || $doOtherActions) {
	parseActionsByOthers(@lines);
	}
	if ($doAll) {
	parseVAOrdersNotices(@lines);
	}
	if ($doAll || $doPaidClaims) {
	parsePaidClaims(@lines);
	}
    }
    
}

sub parsePracticeOffices{ 
    my @lines = @_; 
    my $i = 0;
    my ($licenseNo, @name, @type, @street, @city, @state, @zip, @subzip, @phone, @lastUpdated, @percent, @days, @translation, @typeOfTranslation);
    my $numAdditionalOffices = 0;

    STARTOFLOOP: for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Practice Address/) {
	    if ($lines[$i] =~ m/(Primary|Additional) Practice Address/) {
		if ($1 eq "Primary") {
		    push(@type, $1);
		} else {
		    $numAdditionalOffices++;
		    push(@type, "$1-$numAdditionalOffices");
		}
	    } else {
		generateError("Could not determine primary or additional address in $lines[$i]");
	    }
	    $i++;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		push(@lastUpdated, $1);
	    } else {
		generateError("Could not find last updated in $lines[$i]");
	    }
	    my $thisName = "";
	    $i += 2;
	    while ($lines[$i] =~ m/^\s*$/) { $i++; } #advance to non-empty line
	    if ($lines[$i] =~ m/None Reported/) {
		redo STARTOFLOOP; # No address here. Keep checking, even though you'll never find another one.
	    }
	    # The non-street part of the address starts with spaces and something 
	    # NOT  a number. The street part starts with a number. It also does not contain what
	    # appears to be a phone. This sometimes fails, so
	    # we do not treat bad addresses as errors.
	    while ($lines[$i] =~ m/^\s*([^0-9< \t][^<]+)\</ && $lines[$i] !~ m/\d\d\d-? ?\d\d\d-? ?\d\d\d\d/) {
		if ($thisName ne "") { $thisName = $thisName . ", "; }
		$thisName = $thisName . $1;
		$i++;
	    }
	    # Not necessarily an error, sometimes practice name is not available.
	    #if ($thisName eq "") { generateError("Could not find practice name in $lines[$i]"); }
	    push (@name, $thisName);
	    
	    #Should not need to increment $i as it was incremented in loop above.
	    if ($lines[$i] =~ m/\s*([^<]+)\</) {
		push(@street, $1);
	    } else { 
		# not necessarily an error - some don't have streets.
		#generateError("Could not find street in $lines[$i]");
		push(@street, "");
	    }
	    my $complete = 0;
	    # Try to match the second line of address first in the line above the street, then on subsequent lines.
	    for (my $j = $i - 1; $j < $i + 3 && !$complete; $j++) {

		if ($lines[$j] =~ m/([^>]+), (\w\w) (\d\d\d\d\d)(\d\d\d\d)?/) {
		    push(@city, $1);
		    push(@state, $2);
		    push(@zip, $3);
		    $complete = 1;
		    if ($lines[$j] =~ m/\d\d\d\d\d(\d\d\d\d)/) {
			push(@subzip, $1);
		    } else {
			push(@subzip, "");
		    }
		} elsif($lines[$j] =~ m/([^>]+), (.*) (\d\d\d\d\d)(\d\d\d\d)?/) {
		    # This section finds full state names (Virginia) or weird abbreviations (Va., Ill., etc.)
		    # The goal is to make sure we don't miss any zip codes.
		    push(@city, $1);
		    push(@state, $2);
		    push(@zip, $3);
		    $complete = 1;
		    if ($lines[$j] =~ m/\d\d\d\d\d(\d\d\d\d)/) {
			push(@subzip, $1);
		    } else {
			push(@subzip, "");
		    }
		} else {
		    #print "Didn't find it in $lines[$j]\n";
		}
	    }
	    if (!$complete) {
		#generateError("Could not find rest of address in $lines[$i]"); 
		# Not necessarily an error, sometimes the address is VERY badly formed
		push(@city, "");
		push(@state, "");
		push(@zip, "");
		push(@subzip, "");
	    }
	    
	    while ($i < scalar(@lines) && $lines[$i] !~ m/Phone:/ && $lines[$i] !~ m/Location Details/) { $i++; }
	    if ($lines[$i] =~ m/Phone:\D+(\d+-?\s?\d+-?\s?\d+)/) {
		push(@phone, $1);
	    } else { 
		#generateError("Could not find phone in $lines[$i]"); 
		push(@phone, "");
	    }

	    my $overflow = 0;
	    while ($overflow < 10 && $lines[$i] !~ m/%/ && $lines[$i] !~ m/Days that pract/ && $lines[$i] !~ m/Translation/) { $i++; $overflow++; }
	    if ($lines[$i] =~ m/(\d+%)/) {
		push(@percent, $1);
	    } else { 
		#Never an error...
		#generateError("Could not find percent of time in $lines[$i]"); 
		push(@percent, "");
	    }
	    
	    $overflow = 0;
	    while ($overflow < 10 && $lines[$i] !~ m/Days that practitioner/ && $lines[$i] !~ m/Translation/) { $i++; $overflow++; }
	    if ($lines[$i] =~ m/Blue\"\>\<?b?\>?\s?([^<]+)/) {
		push(@days, $1);
	    } else { 
		# As always, not an error, sometimes this isn't seen.
		#generateError("Could not find days of week in $lines[$i]"); 
		push(@days, "");
	    }

	    $i += 1 if $lines[$i] !~ m/Translation/; 
	    if ($lines[$i] =~ m/Translation services are available/) {
		push(@translation, "available");
		
		my $type = "";
		while ($lines[$i] =~ m/\<b\>\s?([^<]+)/) {
		    if ($type ne "") { $type = $type . ", "; } # add comma if necessary to separate
		    $type = $type . $1;
		    $i++;
		}
		#if ($type eq "") { generateError("Found no translation servces when they were available in $lines[$i]"); }
		push(@typeOfTranslation, $type);
	    } else { 
		push(@translation, "not available");
		push(@typeOfTranslation, "none");
	    }
	}
    }

    # Print the results!
    for ($i = 0; $i < scalar(@name); $i++) {
	print PRACTICEOFFICES tabSeparate($licenseNo,$name[$i],$type[$i],$street[$i],$city[$i],$state[$i],$zip[$i],$subzip[$i],$phone[$i],$lastUpdated[$i],$percent[$i],$days[$i],$translation[$i],$typeOfTranslation[$i]);
    }
}
sub parseNonEnglishLanguages{ 
    my @lines = @_;
    my $i;
    my $licenseNo;
    my $numAdditionalOffices = 0;

    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Practice Address/) {
	    my $officeName;
	    if ($lines[$i] =~ m/(Primary|Additional) Practice Address/) {
		if ($1 eq "Primary") {
		    $officeName = $1;
		} else {
		    $numAdditionalOffices++;
		    $officeName = "$1-$numAdditionalOffices";
		}
	    }
	    $i += 3;
	    
	    # Go to line with languages or end of box.
	    while ($lines[$i] !~ m/\<\/div/i) {
		if ($lines[$i] =~ m/Non-English Languages spoken in Office\<br\>(.*?)\<br\>\<\/li/i) {
		    my @languages = split(/\<br\>/i, $1);
		    my $lang;
		    foreach $lang (@languages) {
			print NONENGLISHOFFICES tabSeparate($licenseNo, $officeName, $lang);
		    }
		}
		if ($lines[$i] =~ m/Non\-English Languages spoken by Practitioner\<br\>(.*?)\<br\>\<\/li/i) {
		    my @languages = split(/\<br\>/i, $1);
		    my $lang;
		    foreach $lang (@languages) {
			print NONENGLISHPRACTITIONER tabSeparate($licenseNo, $officeName, $lang);
		    }
		}
		$i++;
	    }
	}

    }
    
}
sub parseVAHospitals{ 
    my @lines = @_; 
    my $i = 0;
    my $lastUpdated = "";
    my $licenseNo;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Virginia/ && $lines[$i + 1] =~ m/Hospital Affiliations/) {
	    $i += 2;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find VA Hospital Last Updated in $lines[$i]"); }

	    $i += 2;
	    while ($lines[$i] =~ m/^(.*)\<br\>/i) {
		print VAHOSPITALS tabSeparate($licenseNo, $lastUpdated, $1);
		$i++;
	    }
	    return;
	}
    }
    if ($lastUpdated eq "") { generateError("Could not find VA Hospital Info"); }
}
sub parseOtherHospitals{ 
    my @lines = @_; 
    my $i = 0;
    my $lastUpdated = "";
    my $licenseNo;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Hospital Affiliations in States Other/) {
	    $i++;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Non-VA Affiliation Last Updated in $lines[$i]"); }

	    $i += 2;
	    while ($lines[$i] =~ m/^(.*\<br\>.*)/i) {
		my $locString = $1;
		my @locations = split(/\<br\>/, $locString);
		foreach $locString (@locations) {
		    $locString =~ s/^\s*//;
		    $locString =~ s/\s*$//;
		    if ($locString ne "") {
			print OTHERHOSPITALS tabSeparate($licenseNo, $lastUpdated, $locString);
		    }
		}
		$i++;
	    }
	    return;
	}
    }
    if ($lastUpdated eq "") { generateError("Could not find VA Hospital Info"); }
}

sub parseGradSchool{ 
    my @lines = @_; 
    my $i;
    my $licenseNo;
    my $lastUpdated;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Medical, Osteopathic, or Podiatric School/) {
	    # We assume there can be multiple grad schools, but we don't really know.
	    $i++;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Grad Last Updated in $lines[$i]"); }
	    my ($gradSchool, $state, $country, $city, $year);
	    $gradSchool = $state = $city = $year = "";
	    $country = "USA";
	    $i += 2;
	    while ($lines[$i] !~ m/\/div/) {
		if ($lines[$i] =~ m/Grad School: ([^<]+)/) {
		    if ($gradSchool ne "") {
			# Found second grad school. Write out the old one.
			print GRADSCHOOL tabSeparate($licenseNo, $lastUpdated, $gradSchool, $city, $state, $country, $year);
			$state = $city = $year = "";
			$country = "USA";
		    }
		    $gradSchool = $1;
		    if ($gradSchool =~ m/ - (.*?) ([A-Z][A-Z])/) {
			$city = $1;
			$state = $2;
		    }
		} elsif ($lines[$i] =~ m/Year Completed\D+(\d+)/) {
		    $year = $1;
		} elsif ($lines[$i] =~ m/City: ([^<]+)/) {
		    $city = $1;
		} elsif ($lines[$i] =~ m/State: ([^<]+)/) {
		    $state = $1;
		} elsif ($lines[$i] =~ m/Country: ([^<]+)/) {
		    $country = $1;
		}
		$i++;
	    }
	    print GRADSCHOOL tabSeparate($licenseNo, $lastUpdated, $gradSchool, $city, $state, $country, $year);
	    return;
	}
    }
}
sub parsePostGradSchool{ 
my @lines = @_; 
    my $i;
    my $licenseNo;
    my $lastUpdated;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Medical, Osteopathic, or Podiatric Post Grad School/) {
	    $i++;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Post Grad Last Updated in $lines[$i]"); }
	    my ($gradSchool, $state, $country, $city, $year, $specialty, $stage);
	    $gradSchool = $state = $city = $year = $specialty = $stage = "";
	    $country = "USA";
	    $i += 2;
	    while ($lines[$i] !~ m/\/div/) {
		if ($lines[$i] =~ m/\<br\>\<br\>/) {
		    print POSTGRADSCHOOL tabSeparate($licenseNo, $lastUpdated, $specialty, $gradSchool, $city, $state, $country, $stage, $year);
		    $gradSchool = $state = $city = $year = $specialty = $stage = "";
		    $country = "USA";
		}
		elsif ($lines[$i] =~ m/Year (\w+)/ or $lines[$i] =~ m/(Internship|Residency|Fellowship)/i) {
		    $stage = $1;
		} elsif ($lines[$i] =~ m/Completed: (\d+)/) {
		    $year = $1;
		} elsif ($lines[$i] =~ m/([^<]+)\<br/) {
		    if ($specialty eq "") { $specialty = $1;
		    } elsif ($gradSchool eq "") { $gradSchool = $1;
		    } elsif ($country eq "") { $country = $1; }
		} elsif ($lines[$i] =~ m/([^<]+), ?([A-Z]\.?[A-Z])/) {
		    $city = $1;
		    $state = $2;
		    $state =~ s/\.//;
		} elsif ($lines[$i] =~ m/([^<]+),/) {
		    $city = $1;
		} elsif ($lines[$i] =~ m/([^<]+)/) {
		    $state = $1;
		}
		$i++;
	    }
	    if ($specialty ne "") { print POSTGRADSCHOOL tabSeparate($licenseNo, $lastUpdated, $specialty, $gradSchool, $city, $state, $country, $stage, $year); }
	    return;
	}
    }
}
sub parseContinuingEd { 
    my @lines = @_; 
    my $i;
    my $licenseNo;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/restitle.*Continuing Education/) {
	    $i++;
	    my ($lastUpdated, $continuingHours, $since);
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Continuing Ed Last Updated in $lines[$i]"); }
	    $i += 3;
	    if ($lines[$i] =~ m/Continuing Hours\D+(\d+)/) {
		$continuingHours = $1;
	    } else {
		return; # no continuing hours.
	    }
	    $i++;
	    if ($lines[$i] =~ m/Since\D+(\d+)/) {
		$since = $1;
		print CONTINUINGED tabSeparate($licenseNo, $lastUpdated, $continuingHours, $since);
		return; # Done now!
	    } else { 
		generateAlert("Did not find a since field for continuing ed when hours were found");
		$since = "";
		print CONTINUINGED tabSeparate($licenseNo, $lastUpdated, $continuingHours, $since);
	    }
	    return;
	}
    }
}
sub parseBoardCert{ 
    my @lines = @_; 
    my $i;
    my $licenseNo;
    my $lastUpdated;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Board Certification /) {
	    $i += 3;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Board Cert Last Updated in $lines[$i]"); }
	   
	    $i += 2;
	    my ($specialty, $year, $expire);
	    $specialty = $year = $expire = "";
	    while ($lines[$i] !~ m/\/div/) {
		if ($lines[$i] =~ m/Year of Initial\D+(\d*).*Current Certification Expires:\<b\> (indefinite|\d*)/i) {
		    $year = $1;
		    $expire = $2;
		} elsif ($lines[$i] =~ m/([^<]+)\<br/) {
		    if ($specialty ne "") {
			print BOARDCERT tabSeparate($licenseNo, $lastUpdated, $specialty, $year, $expire);
			$year = $expire = "";
		    }
		    $specialty = $1;
		}
		$i++;
	    }
	    if ($specialty ne "") {
		print BOARDCERT tabSeparate($licenseNo, $lastUpdated, $specialty, $year, $expire);
	    }
	    return;
	}
    }
}
sub parsePracticeAreas { 
    my @lines = @_; 
    my $i;
    my $licenseNo;
    my $lastUpdate;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Self-Designated P/) {
	    $i++;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdate = $1;
	    } else { generateError("Could not find Practice Last Updated in $lines[$i]"); }

	    $i += 2;
	    while ($lines[$i] !~ m/\/div/) {
		if ($lines[$i] =~ m/([^<]+)\</) {
		    print PRACTICEAREAS tabSeparate($licenseNo, $lastUpdate, $1);
		}
		$i++;
	    }
	    
	    return;
	}
    }
}
sub parseInsurancePlans{ 
    my @lines = @_; 
    my $i;
    my $lastUpdated;
    my $licenseNo;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Insurance Plans/) {
	    $i++;
	    if ($lines[$i] =~ m/Last Updated ([^<]*)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Insurance Last Updated in $lines[$i]"); }

	    $i += 2;
	    while ($lines[$i] !~ m/\/div/) {
		if ($lines[$i] =~ m/^\s*(\<b.*)\<br\>\<br\>/) {
		    my @providers = split(/\<br\>/, $1);
		    my $provider;
		    foreach $provider (@providers) {
			if ($provider =~ m/b>([^<>]+).*\(([^)]+)\)/) {
			    print INSURANCEPLANS tabSeparate($licenseNo, $lastUpdated, $1, $2);
			} # Else is not necessarily an error. Some say <b>none</b> w/o (something) 
			#else { generateError("Did not find insurance info in $provider"); }
		    }
		}
		$i++;
	    }
	    
	    return;
	}
    }

}
sub parseHonors{ 
    my @lines = @_; 
    my $i;
    my $licenseNo;
    my $lastUpdated;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Honors/ && $lines[$i + 1] =~ m/and Awards/) {
	    $i += 2;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Honors Last Updated in $lines[$i]"); }
	   
	    $i += 2;
	    my ($name, $institute);
	    $name = $institute = "";
	    while ($lines[$i] !~ m/\/div/) {
		if ($lines[$i] =~ m/([^<]+)\<br\>\<br\>/) {
		    if ($name ne "") {
			print HONORS tabSeparate($licenseNo, $lastUpdated, $name, $institute, $1);
			$name = $institute = "";
		    }
		} elsif ($lines[$i] =~ m/([^<]+)\<br\>/) {
		    if ($name eq "") { 
			$name = $1;
		    } else {
			$institute = $1;
		    }
		}
		$i++;
	    }
	    return;
	}
    }
}
sub parseAcademia { 
    my @lines = @_; 
    my $i;
    my $licenseNo;
    my $lastUpdated;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Academic Appointments\</) {
	    $i++;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Academic Last Updated in $lines[$i]"); }
	    my ($university, $rank, $yearStart, $yearEnd);
	    $university = $rank = $yearStart = $yearEnd = "";
	    $i += 2;
	    while ($lines[$i] !~ m/\/div/) {
		if ($lines[$i] =~ m/Rank:\<b\> ?([^<]+)/) {
		    $rank = $1;
		    
		} 
		# Appointments always end with a year, so if we find a year we must print.
		elsif ($lines[$i] =~ m/Years:.*?(\d+)\s*-\s*(\d+|pr?e?s?e?n?t?)/i) { 
		    $yearStart = $1;
		    $yearEnd = $2;
		    print ACADEMIA tabSeparate($licenseNo, $lastUpdated, $university, $rank, $yearStart, $yearEnd, "US");
		    $university = $rank = $yearStart = $yearEnd = "";
		} elsif ($lines[$i] =~ m/Years:/) {
		    $yearStart = $yearEnd = "";
		    print ACADEMIA tabSeparate($licenseNo, $lastUpdated, $university, $rank, $yearStart, $yearEnd, "US");
		    $university = $rank = $yearStart = $yearEnd = "";
		} elsif ($lines[$i] =~ m/([^<]+)\<\/b/) {
		    $university = $1;
		}
		$i++;
	    }
	}

	if ($lines[$i] =~ m/Academic Appointments - Non-US/) {
	    $i++;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Non-US Academic Last Updated in $lines[$i]"); }
	    my ($university, $rank, $yearStart, $yearEnd);
	    $university = $rank = $yearStart = $yearEnd = "";
	    $i += 2;
	    while ($lines[$i] !~ m/\/div/) {
		if ($lines[$i] =~ m/Rank:\<b\> ?([^<]+)/) {
		    $rank = $1;
		} elsif ($lines[$i] =~ m/Years:.*?(\d+)\s*-\s*(\d+|pr?e?s?e?n?t?)/i) {
		    $yearStart = $1;
		    $yearEnd = $2;
		} elsif ($lines[$i] =~ m/Years:/) {
		    $yearStart = $yearEnd = "";
		} elsif ($lines[$i] =~ m/([^<>]+)\<\/b/) {
		    if ($university ne "") {
			# Found second appointment. Write out the old one
			print ACADEMIA tabSeparate($licenseNo, $lastUpdated, $university, $rank, $yearStart, $yearEnd, "Non-US");
			$university = $rank = $yearStart = $yearEnd = "";
		    }
		    $university = $1;
		}
		$i++;
	    }
	    if ($university ne "") {
		print ACADEMIA tabSeparate($licenseNo, $lastUpdated, $university, $rank, $yearStart, $yearEnd, "Non-US");
		#generateAlert("Found non-us appointment. Make sure this worked");
	    }
	    return;
	}
    }
}
sub parsePublications { 
    my @lines = @_; 
    my $i;
    my $licenseNo;
    my $lastUpdated;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Publications/ && $lines[$i + 1] =~ m/up to ten/) {
	    $i += 2;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Publications Last Updated in $lines[$i]"); }
	   
	    $i += 2;
	    my ($journal, $title, $issue, $dateOfPublish, $website);
	    $journal = $title = $issue = $dateOfPublish = $website = "";
	    while ($lines[$i] !~ m/\/div/) {
		if ($lines[$i] =~ m/\<i\>([^<]+)/) {
		    if ($title ne "") {
			print PUBLICATIONS tabSeparate($licenseNo, $lastUpdated, $title, $journal, $issue, $dateOfPublish, $website);
			$journal = $title = $issue = $dateOfPublish = $website = "";
		    }
		    $title = $1;
		} elsif ($lines[$i] =~ m/Date: \<\/b\> ?([^<]+)/) {
		    $dateOfPublish = $1;
		} elsif ($lines[$i] =~ m/(.+)\<br\>/) {
		    if ($journal eq "") { 
			$journal = $1;
		    } elsif ($issue eq "") {
			$issue = $1;
		    } else {
			$website = $1;
		    }
		}
		$i++;
	    }
	    if ($title ne "") { print PUBLICATIONS tabSeparate($licenseNo, $lastUpdated, $title, $journal, $issue, $dateOfPublish, $website); }
	    return;
	}
    }
}
sub parseFelony{ 
    my @lines = @_;
    my $i;
    my $licenseNo;
    my $lastUpdated;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Felony Conviction /) {
	    $i += 1;
	    if ($lines[$i] =~ m/Last Updated ([^<]*)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Felony Last Updated in $lines[$i]"); }
	   
	    $i += 2;
	    my $data;
	    $data = "";
	    while ($lines[$i] !~ m/\/div/) {
		$data = $data . $lines[$i];
		$i++;
	    }
	    if ($data !~ m/None Reported/) {
		print FELONY tabSeparate($licenseNo, $lastUpdated, $data);
		generateAlert("Found felony data! Make sure it worked!");
	    }
	    return;
	}
    }
}
sub parseActionsByOthers{ 
my @lines = @_; 
    my $i;
    my $licenseNo;
    my $lastUpdated;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Actions Taken by States/) {
	    $i++;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Actions by Others Updated in $lines[$i]"); }
	    my ($date, $entity);
	    $date = $entity = "";
	    $i += 2;
	    while ($lines[$i] !~ m/\/div/) {
		if ($lines[$i] =~ m/Action Taken:\<b\> ?([^<]+)/) {
		    print ACTIONSBYOTHERS tabSeparate($licenseNo, $lastUpdated, $entity, $1, $date);
		    $date = $entity = "";
		} elsif ($lines[$i] =~ m/Date:\<b\> ?([^<]+)/) {
		    $date = $1;
		} elsif ($lines[$i] =~ m/Entity Taking Action:\<b\> ?([^<]+)/) {
		    $entity = $1;
		} 
		$i++;
	    }
	    return;
	}
    }
}
sub parseVAOrdersNotices{ 
    my @lines = @_;
    my $i;
    my $licenseNo;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Virginia Board of Medicine Notices/) {
	    $i += 3;
	    my $url;
	    while ($lines[$i] !~ m/\/div/) {
		if ($lines[$i] =~ m/href="([^"]+)/) {
		    print VAORDERSNOTICES tabSeparate($licenseNo, $1);
		}
		$i++;
	    }
	    return;
	}
    }
}
sub parsePaidClaims{ 
    my @lines = @_;
    my $i;
    my $licenseNo;
    my $lastUpdated;
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	}
	if ($lines[$i] =~ m/Paid Claims in the last ten years/) {
	    $i += 1;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$lastUpdated = $1;
	    } else { generateError("Could not find Paid Claims Last Updated in $lines[$i]"); }
	   
	    $i += 2;
	    my $data;
	    $data = "";
	    while ($lines[$i] !~ m/\/div/) {
		$data = $data . $lines[$i];
		$i++;
	    }
	    if ($data !~ m/None Reported/) {
		# Parse the data into its fields:
		my ($specialty, $location, $year, $amount, $Comments, $numSameSpecialty, $percentage);
		$specialty = $location = $year = $amount =  $Comments =  $numSameSpecialty =  $percentage = "";
		if ($data =~ m/Specialty:\<b\>\s*([^<]+)/i) {
		    $specialty = $1;
		}
		if ($data =~ m/Location:\<b\>\s*([^<]+)/i) {
		    $location = $1;
		}
		if ($data =~ m/Year:\<b\>\s*([^<]+)/i) {
		    $year = $1;
		}
		if ($data =~ m/Amount of this claim is:\<b\>\s*([^<]+)/i) {
		    $amount = $1;
		}
		if ($data =~ m/Practitioner Comments:\<br\>\<b\>\s*([^<]+)/i) {
		    $Comments = $1;
		}
		if ($data =~ m/(\d+) Practitioners with same specialty/i) {
		    $numSameSpecialty = $1;
		}

		if ($data =~ m/(\d+\.\d*)% Practitioners with claims in this specialty/i) {
		    $percentage = $1;
		}

		print PAIDCLAIMS tabSeparate($licenseNo, $lastUpdated, $specialty, $location, $year, $amount, $Comments, $numSameSpecialty, $percentage);
	    }
	    return;
	}
    }
}
#TODO: Add last updated stuff.
sub parseDoctorInfo { 
    my @lines = @_;
    my $i = 0;
    my ($licenseNo, $name, $lastName, $firstName, $middleName, $suffix, $email, $website, $issue, $expiration, $status, $yearsUpdated, $yearsInUS, $yearsOutOfUS, $medicaidUpdated, $participateMedicaid, $acceptMedicaid, $medicareUpdated, $medicare);
    $medicare = "";
    $yearsInUS = 0;
    $yearsOutOfUS = 0;
    $participateMedicaid = ""; 
    $acceptMedicaid = "";
    $yearsUpdated = $medicaidUpdated = $medicareUpdated = "";
    $email = $website = "";

    my $nameLine = -1; # For reference later so we can correct the capitalization we found in the name line.
    
    for ($i = 0; $i < scalar(@lines); $i++) {
	if ($lines[$i] =~ m/\<H1\>([^<]+)\</) {
	    $nameLine = $i;
	    $name = $1;
	    $name =~ s/\s*\(.*\)//g; # handle doctors with names like SYED ZAFAR AHSAN (), MD or Jane P. Wootton (Pendleton), MD
	    if ($name =~ m/(\S+) (.*?) ([^, \t]+)\s*,/) {
		$firstName = $1;
		$middleName = $2;
		$lastName = $3;
		my $suffixRE = qr{(Jr|Sr|III|II|IV|V)\.?}i;
		if ($lastName =~ m/^$suffixRE$/i) {
		    # In this case, last name was set to the suffix, and the actual last name
		    # is in the middle name.
		    $suffix = $1;
		    $middleName =~ m/\s*(\w+)$/;
		    $lastName = $1;
		    $middleName =~ s/\s*\w+$//;
		} else {
		    $suffix = "";
		}
	    } else { generateError("Could not hand name $name"); }
	} elsif ($lines[$i] =~ m/LICENSE # \<b\>(\d+)\</) {
	    $licenseNo = $1;
	} elsif ($lines[$i] =~ m/\<a href=mailto:([^>]+)>/) {
	    $email = $1;
	    $i += 1;
	    if ($lines[$i] =~ m/\<a[^>]+\>([^<]+)\</) {
		$website = $1;
	    } else {
		if ($email !~ m/vahealthprovider\.com/) {
		    #generateError("Could not find website in line $lines[$i]");
		    # Not an error, necessarily. Some don't have websites
		    $website = "";
		}
	    }
	} elsif ($lines[$i] =~ m/Issue Date:\s+\<b\>([^<]+)\</) {
	    $issue = $1;
	} elsif ($lines[$i] =~ m/Expiration Date:\s+\<b\>([^<]+)\</) {
	    $expiration = $1;
	} elsif ($lines[$i] =~ m/Status:/) {
	    $i++;
	    if ($lines[$i] =~ m/\<b\>([^<]+)\</) {
		$status = $1;
	    } else {
		generateError("Could not find status in $lines[$i]");
	    }
	}
	if ($lines[$i] =~ m/restitle.*Years in Active Clinical Practice/) {
	    $i += 2;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$yearsUpdated = $1;
	    } else { generateError("Could not find years last updated in $lines[$i]"); }
	}
	if ($lines[$i] =~ m/Years in Active Clinical Practice Inside US\/Canada:\D+(\d+)/) {
	    $yearsInUS = $1;
	}
	if ($lines[$i] =~ m/Years in Active Clinical Practice Outside US\/Canada:\D+(\d+)/) {
	    $yearsOutOfUS = $1;
	}

	if ($lines[$i] =~ m/restitle.*Medicaid/) {
	    $i++;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$medicaidUpdated = $1;
	    } else { generateError("Could not find medicaid last updated in $lines[$i]"); }

	}
	if ($lines[$i] =~ m/Does Not Participate in the Virginia Medicaid/) {
	    $participateMedicaid = "no";
	} elsif ($lines[$i] =~ m/Participate in the Virginia Medicaid/) {
	    $participateMedicaid = "yes";
	}
	if ($lines[$i] =~ m/Is not accepting new Virginia Medicaid/) {
	    $acceptMedicaid = "no";
	} elsif ($lines[$i] =~ m/Is accepting new Virginia Medicaid/) {
	    $acceptMedicaid = "yes";
	}

	if ($lines[$i] =~ m/restitle.*Medicare/) {
	    $i++;
	    if ($lines[$i] =~ m/Last Updated ([^<]+)/) {
		$medicareUpdated = $1;
	    } else { generateError("Could not find medicare last updated in $lines[$i]"); }

	}
	if ($lines[$i] =~ m/Medicare \<i\>([^<]+)/) {
	    $medicare = $1;
	}

    }

    # We will for now just replace the name fields with the ones we found originally.
    #print "Before consulting hash, last = $lastName, mid = $middleName, first = $firstName\n";
    if ($nameHash{$licenseNo}) {
	my @name = @{$nameHash{$licenseNo}};
	$lastName = $name[0];
	$firstName = $name[1];
	$middleName = $name[2];
	#print "Hash value is last = $lastName, mid = $middleName, first = $firstName\n";

	# Figure out the correct capitalization either by refering to the page or by guessing.
	if ($nameLine != -1 && $lines[$nameLine] =~ m/($lastName)/i) {
	    $lastName = $1;
	} else { 
	    $lastName = capitalize($lastName);
	}
	if ($nameLine != -1 && $lines[$nameLine] =~ m/($firstName)/i) {
	    $firstName = $1;
	} else { 
	    $firstName = capitalize($firstName);
	}
	if ($nameLine != -1 && $lines[$nameLine] =~ m/($middleName)/i) {
	    $middleName = $1;
	} else { 
	    $middleName = capitalize($middleName);
	}

    } else {
	generateError("Did not precompute name of license $licenseNo");
    }
    #print "After consulting hash, last = $lastName, mid = $middleName, first = $firstName\n";
    
    print DOCTORINFO tabSeparate($licenseNo,$lastName, $firstName, $middleName, $suffix, $email,$website,$issue,$expiration,$status,$yearsUpdated, $yearsInUS,$yearsOutOfUS,$medicaidUpdated, $participateMedicaid,$acceptMedicaid,$medicareUpdated, $medicare);
    return 1 if $status =~ /Expired/;
    return 0;

}

# Capitalize a name in the way we usually capitalize names.
sub capitalize
{
    my $capitalizeNext = 1;
    my $name = shift;
    my $result = "";
    while ($name ne "") {
	my $curLetter = substr($name, 0, 1);
	if ($capitalizeNext) {
	    $curLetter =~ tr/a-z/A-Z/;
	} else {
	    $curLetter =~ tr/A-Z/a-z/;
	}
	$result .= $curLetter;
	$capitalizeNext = 0;
	if ($curLetter =~ m/\W/) {
	    $capitalizeNext = 1;
	}
	$name = substr($name, 1);
    }
    return $result;
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

sub generateError
{
    my $errString = $_[0];
    print "Error in processing $fullFilename: $errString\n";
    closeAll();
    exit(3);
}

sub generateAlert
{
    my $alertString = $_[0];
    print "Alert in processing $fullFilename: $alertString\n";
}

sub closeAll
{
    #Close all output files
    if ($doAll || $doPracticeOffices) {
    close(PRACTICEOFFICES);
    }
    if ($doAll) {
    close(NONENGLISHOFFICES);
    close(NONENGLISHPRACTITIONER);
    close(VAHOSPITALS);
    }
    if ($doAll || $doOtherHospitals) {
    close(OTHERHOSPITALS);
    }
    if ($doAll) {
    close(GRADSCHOOL);
    }
    if ($doAll || $doPostGrad) {
    close(POSTGRADSCHOOL);
    }
    if ($doAll) {
    close(CONTINUINGED);
    }
    if ($doAll || $doBoardCert) {
    close(BOARDCERT);
    }
    if ($doAll) {
    close(PRACTICEAREAS);
    close(INSURANCEPLANS);
    close(HONORS);
    }
    if ($doAll || $doAcademicAppoint) {
    close(ACADEMIA);
    }
    if ($doAll) {
    close(PUBLICATIONS);
    close(FELONY);
    }
    if ($doAll || $doOtherActions) {
    close(ACTIONSBYOTHERS);
    }
    if ($doAll) {
    close(VAORDERSNOTICES);
    }
    if ($doAll || $doPaidClaims) {
    close(PAIDCLAIMS);
    }
    close(DOCTORINFO);

}
__END__



