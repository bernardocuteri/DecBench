#!/usr/bin/perl


if(scalar(@ARGV) < 1) {
	print "Error: input file expected.\n";	
	die;
}
$input = $ARGV[0];

open(INPUT, $input);
@lines = <INPUT>; 

$line = $lines[0];

@split = split(/\)/,$line);

$noOut=0;
$withTester = 0;
if(scalar(@ARGV) > 1) {
	if($ARGV[1] eq "no_out") {
		$noOut=1;
	}
	else {
		$withTester=1;
	}
}

foreach $predicate (@split) {
	if($predicate =~ m/testcaseCommand\((\w+),(\w+),(\w+),\"([^\"]*)\",\"([^\"]*)\",\"([^\"]*)\"/) {
		$command{$1."/".$2."/".$3} = "$5 $6";
		$testcase{$1."/".$2."/".$3} = "$2-$3";
		$domains{$1."/".$2} = $1."/".$2;
		$folderAndFile{$1."/".$2."/".$3} = $1."/".$2."/refinedBenchmarks/$2-$3";
		$testcaseSolver{$1."/".$2."/".$3} = "$1";
		$testcaseDomain{$1."/".$2."/".$3} = "$2";
		$solvers{$1} = "$4";
		$localKey = $1."/".$2."/".$3;
		if($6 =~ m/([^\/]*)$/ ) {
			$file{$localKey} = $1;
		}
	}
	elsif($predicate=~ m/requires\((\w+),(\w+),(\w+),(\w+),(\w+),(\w+),(\w+)/) {
		if($7 eq 'strong') {
			push (@{$dependencies{$1."/".$2."/".$3}}, $1."/".$5."/".$5."-".$6.".xml");
		}
		else {
			push (@{$dependencies{$1."/".$2."/".$3}},  $1."/".$5."/".$5."-".$6);
		}
	}
	elsif($predicate =~ m/resourceLimit\((\w+),(\w+),(\w+),(\d+)/) {
		$limit = " $4";
		if($3 eq "cpu")	{
			$limitType = " -C";			
		}
		elsif($3 eq "wall") {
			$limitType = " -W";	
		}
		elsif($3 eq "virtualMemory") {
			$limitType = " -M";	
		}
		$limit = $limitType.$limit;	
		$limits{$1.$2} = $limits{$1.$2}.$limit;
	}
	elsif($predicate =~ m/instancesFolder\(\"([^\"]*)\"/) {
		$instancesFolder = $1;

	}

	
	
}
foreach $predicate (@split) {
	if(@dataMatch = $predicate=~ m/testcaseExecutionData\((\w+),(\w+),(\w+),\"([^\"]+)\",\"([^\"]+)\"/) {
		
		$id = $1."/".$3."/".$2;
		$oldCommand = $command{$id};
		if($3 eq "") {
			$command{$id} = "$5 ".$oldCommand;
		}
		else {
			$command{$id} = "$4$5 ".$oldCommand;
		}
	}
}
if($withTester==1) {
	print "CHECKER = ./$ARGV[1]\n";
} 
print "RS = ./runsolver\n";
print "FOLDER = ";
$date = qx(date "+%Y-%m-%d\_%H.%M.%S");
chomp $date;
print "$date\n";
qx(mkdir "$date");
foreach $key(keys %solvers) {
	qx(mkdir "$date/$key");
	print "$key = $solvers{$key}\n";
}
foreach $domain(values %domains) {
	qx(mkdir "$date/$domain");
	qx(mkdir "$date/$domain/roughBenchmarks");
	qx(mkdir "$date/$domain/refinedBenchmarks");
	qx(mkdir "$date/$domain/outputs");
}

print "all: execution";
if($withTester==1) {
	print " test";
} 
print "\n";

print "execution: ";
foreach $key(keys %command) {
	print "\$(FOLDER)/$folderAndFile{$key}.xml ";
}
print "\n";


foreach $key(keys %command) {
	print "\$(FOLDER)/$folderAndFile{$key}.xml: ";
	for($i=0;$i<scalar(@{$dependencies{$key}});$i++) {
		print "@{$dependencies{$key}}[$i] ";
	}
	$solverCommand = $testcaseSolver{$key};
	$domainCommand = $testcaseDomain{$key};
	$outFile = "\"/dev/null\"";
	if($noOut == 0) {
		$outFile = "\"\$(FOLDER)/$testcaseSolver{$key}/$testcaseDomain{$key}/outputs/$testcase{$key}.dat\"";
	}
	
	print "\n\t\$(RS) $limits{$domainCommand.$solverCommand} -w \"\$(FOLDER)/$testcaseSolver{$key}/$testcaseDomain{$key}/roughBenchmarks/$testcase{$key}.dat\" -o $outFile \$($solverCommand) $command{$key}";
	print "\n";
	print "\t./postprocess.pl -outFolder=\"\$(FOLDER)/$testcaseSolver{$key}/$testcaseDomain{$key}\" -file=\"\$(FOLDER)/$testcaseSolver{$key}/$testcaseDomain{$key}/roughBenchmarks/$testcase{$key}.dat\"\n";
}


if($withTester==1) {
	print "test: ";
	foreach $key(keys %command) {
		print "test$key ";
	}
	print "\n";
	foreach $key(keys %command) {
		print "test$key: \$(FOLDER)/$folderAndFile{$key}.xml\n";
		$solverCommand = $testcaseSolver{$key};
		$domainCommand = $testcaseDomain{$key};
		print "\t\$(CHECKER) \"\$(FOLDER)/$testcaseSolver{$key}/$testcaseDomain{$key}/outputs/$testcase{$key}.dat\" $instancesFolder/ExpectedOutputs/$file{$key}\n";
	}

}

