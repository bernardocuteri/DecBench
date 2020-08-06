#!/usr/bin/perl
$folder = $ARGV[0];
$domain = $ARGV[1];
if($ARGV[0] eq "-h") {
print "Invocare lo script getCactusGraph con parametri: cartella del benchmark, dominio. Salvando l'output su un file.
Eseguire gnuplot sul file ottenuto.

e.g.:
./getCactusGraph.pl ../Core/exampleBench threateningQueens > cactusplot.plot
gnuplot cactus.plot\n";
exit;
}
@solvers = qx(ls $folder);
foreach $solver (@solvers) {
	chomp $solver;
	qx(./Util/xmlProcessor.pl -f="$folder$solver/$domain/refinedBenchmarks/" > unsorted.dat);
	qx(./Util/cactusAggregation.pl unsorted.dat $solver.dat);
}
#qx(rm unsorted.dat);
#qx(rm sorted.dat);
print "set terminal png\n";
print "set output \"cactus_$domain.png\"\n";
print "set xlabel \"Solved Instances\"\n";
print "set ylabel \"Time (s)\"\n";
print("plot");
$firstComma = "";
foreach $solver (@solvers) {
	print " $firstComma\"$solver.dat\" using 2:1 w lp";
	$firstComma =",";
}
print "\n";
