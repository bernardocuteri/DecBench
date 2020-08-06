#!/usr/bin/perl


use Parse::RecDescent;
use Parse::Node;
use Parse::XmlParser;
use Data::Dumper;
use Getopt::Long;

GetOptions(\%options,  "f=s", "v=s");
$benchFolder = $options{f};
$variable = $options{v};
if(!$benchFolder) {
	die "f parameter must be specified\n";
}
#print "#$variable\tcpuTime\twallTime\tmaxVirtualMemory\n";
@instances = qx (ls -B \"$benchFolder\");
foreach $instance (@instances) {
	open FILE, "$benchFolder/$instance";
	@lines = <FILE>;
	$fileContent = "";
	foreach $line(@lines) {
		chomp($line);
		$fileContent = $fileContent.$line;
	}
	$noRoot = 1;
	if(!$parser->node($fileContent)) {
		die "The xml is not well formed for $instance\n";
	}

	foreach $node ($rootNode->getChildren()) {
		$text = $node->getText();
		$nodeName = $node->getName();
		if($nodeName eq $variable) {
			$variableValue = $text;
		}
		elsif($nodeName eq "cpuTime") {
			$cpuTime = $text;
		}
		elsif($nodeName eq "wallTime") {
			$wallTime = $text;
		}
		elsif($nodeName eq "maxVirtualMemory") {
			$maxVirtualMemory = $text;
		}
	}
	if($variableValue) {
		$firstRow = "$variableValue\t";
	}
	if($cpuTime =~ m/^[0-9]+/) {
		print "$firstRow$cpuTime\t$wallTime\t$maxVirtualMemory\n";
	}
}














