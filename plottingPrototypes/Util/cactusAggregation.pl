#!/usr/bin/perl

qx(sort -gk1,1 $ARGV[0] > sorted.dat);

open FILE, "sorted.dat";
if($ARGV[1]) {
	$open = $ARGV[1];
}
else {
	$open = "aggregated.dat";
}
open AGGREGATED, ">$open";
$counter = 0;
$timeCounter = 0;
foreach $line (<FILE>) {
	@lineSplit = split("\t",$line);		
	$time = $lineSplit[0];
	$counter++;
	$timeCounter = $time;
	print AGGREGATED "$timeCounter\t$counter\n";	
	
}














