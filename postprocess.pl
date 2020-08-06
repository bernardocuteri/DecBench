#!/usr/bin/perl

use Getopt::Long;
GetOptions(\%options, "file=s", "outFolder=s","testcaseFile=s");
$file = $options{file} || ".";
$testcaseFile = $options{testcaseFile} || "testcases.dl";
$outFolder = $options{outFolder};
if(!$outFolder) {
	print "outFolder parameter must be specified\n";
	exit;
}
$instanceRegex = "^(\\w+)-(\\w+)";
chomp $file;
push (@output, "<benchmark>\n");
open BENCHMARK, $file;	
@nameSplit = split(/[\/\.]/, $file);
$fileName = @nameSplit[scalar(@nameSplit)-2];
if($fileName =~ m/$instanceRegex/) {
	$domId = $1;
	$fileId = $2;	
}
@lines = <BENCHMARK>;
for $line (@lines) {
	if($line =~ m/Maximum CPU time exceeded/) {		
		push (@output, "\t<wallTime>-</wallTime>\n");
		push (@output, "\t<cpuTime>cpuTimeExceeded</cpuTime>\n");
		push (@output, "\t<maxVirtualMemory>-</maxVirtualMemory>\n");
		$fail = "Maximum CPU time exceeded";
		last;
	}
	elsif($line =~ m/Maximum VSize exceeded/) {
		push (@output, "\t<wallTime>-</wallTime>\n");
		push (@output, "\t<cpuTime>-</cpuTime>\n");		
		push (@output, "\t<maxVirtualMemory>maximumVSizeExceeded</maxVirtualMemory>\n");
		$fail = "Maximum VSize exceeded";
		last;
	}
	elsif($line =~ /^CPU time \(s\): (\d+\.?\d*)/) {
		push (@output, "\t<cpuTime>$1</cpuTime>\n");
	}
	elsif($line =~ /^Real time \(s\): (\d+\.?\d*)/) {
		push (@output, "\t<wallTime>$1</wallTime>\n");
	}
	elsif($line =~ /^Max. virtual memory \(cumulated for all children\) \(KiB\): ([\d]+)/) {
		push (@output, "\t<maxVirtualMemory>$1</maxVirtualMemory>\n");
	}
}
open TESTCASES, "testcases.dl";
@tcLines = <TESTCASES>;	
	
foreach $tcLine(@tcLines) {
	if($tcLine =~ m/^testcase\((\w+),(\w+)/) {
		if(($1==$fileId || $1 eq $fileId) && ($2 eq $domId)) {
			@testNameSplit = split ("\/" , $tcLine);
			$testName = $testNameSplit[scalar(@testNameSplit)-1];
			if($testName =~ m/([^\"]+)/) {
				push (@output, "\t<file>$1</file>\n");
			}
		} 
	}
	elsif($tcLine =~ m/^testcaseData\((\w+),(\w+),(\w+),(\w+)\)/) {
		if(($1==$fileId || $1 eq $fileId) && ($2 eq $domId)) {
			push (@output, "\t<$3>$4</$3>\n");
		} 
	}
	elsif($tcLine =~ m/^testcaseExecutionData\((\w+),(\w+),(\w+),\"([^\"]+)\",\"([^\"]+)\"\)/) {
		if(($2==$fileId || $2 eq $fileId) && ($3 eq $domId)) {
			$value=$5;
			if($4 =~ m/:(\w+)/) {
				push (@output, "\t<$1>$value</$1>\n");
			}
		} 
	}
}

open OUTFILE, ">>$outFolder/refinedBenchmarks/$fileName.xml";	
push (@output, "</benchmark>\n");
for $outLine (@output) {
	print OUTFILE $outLine;
}
close OTUFILE;
close TESTCASES;
close BENCHMARK;
if($fail) {
	die "$fail\n";
}

