#!/usr/bin/perl

if(scalar(@ARGV) != 6) {
	print "Exactly 6 arguments are required: solver, domain, orederingKey, orderingType, orderingStrenght, outFile.\n";
}
else {
	if($ARGV[3] ne "ascending" && $ARGV[3] ne "descending") {
		print "The third argument can only be one of those: {ascending, descending}.\n";
	}
	elsif($ARGV[4] ne "strong" && $ARGV[4] ne "weak") {
		print "The fourth argument can only be one of those: {strong, weak}.\n";
	}
	else {
		open($outFile, ">>$ARGV[5]");
		print $outFile "orderRule($ARGV[0], $ARGV[1], $ARGV[2], $ARGV[3], $ARGV[4]).\n";
		close $outFile;
	}
}

