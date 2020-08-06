#!/usr/bin/perl

qx(sort -n $ARGV[0] > sorted.dat);

open FILE, "sorted.dat";
open AGGREGATED, ">aggregated.dat";

$firstRow = 1;
foreach $line (<FILE>) {
	@lineSplit = split("\t",$line);	
	if($last == $lineSplit[0]) {
		$counter++;
		$cpu = $cpu+$lineSplit[1];
		$wall = $wall+$lineSplit[2];
		$memory = $memory+$lineSplit[3];
	}
	else{
		if($firstRow == 0) {
			$cpu = $cpu/$counter;
			$wall = $wall/$counter;
			$memory = $memory/$counter;
			print AGGREGATED "$last\t$cpu\t$wall\t$memory\n";
		}
		$firstRow=0;
		$counter = 1;
		$last = $lineSplit[0];
		$cpu = $lineSplit[1];
		$wall = $lineSplit[2];
		$memory = $lineSplit[3];		
	}
}
$cpu = $cpu/$counter;
$wall = $wall/$counter;
$memory = $memory/$counter;
print AGGREGATED "$last\t$cpu\t$wall\t$memory\n";














