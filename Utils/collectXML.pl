#!/usr/bin/perl


if($ARGV[0] eq "-h") {
print "Invoke the script with the benchmark folder as the only parameter.
e.g.:
./collectXML.pl ../exampleBench threateningQueens > result.xml\n";
exit;
}
$benchFolder = "$ARGV[0]";
@folders = qx(ls "$benchFolder" -F);
print "<benchmarkSuite>\n";
foreach $folder(@folders) {
	if($folder=~m/\//) {
		chomp $folder;
		chop $folder;
		@problems = qx(ls "$benchFolder/$folder/");
		print "<solver>\n";
		print "\t<name>$folder</name>\n";
		foreach $problem (@problems) {
			chomp $problem;
			@files = qx(ls "$benchFolder/$folder/$problem/refinedBenchmarks/");
			print "\t<problem>\n";
			print "\t\t<name>$problem</name>\n";
			foreach $file(@files) {
				chomp $file;
				$fullFile = "<$benchFolder/$folder/$problem/refinedBenchmarks/$file";
				if($fullFile =~ m/\\/g)
				{
					$fullFile =~ s/\\/\\\\/g;
				}	
				open BENCH, $fullFile;
				@benchLines = <BENCH>;
				foreach $benchLine(@benchLines) {
					print "\t\t$benchLine";
				}
				close BENCH;
				
			}
			print "\t</problem>\n";
		}
		print "</solver>\n";
	}
}
print "</benchmarkSuite>\n";
close INPUT;
