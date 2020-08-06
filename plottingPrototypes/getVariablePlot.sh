./Util/xmlProcessor.pl -f="$1/$2/$3/refinedBenchmarks" -v $4 > unsorted.dat
./Util/sortAndAggregate.pl unsorted.dat
rm unsorted.dat
rm sorted.dat
sed -i '2s/.*/set output \"'$3'_'$4'_'$2'.png\"/' variable.plot
sed -i '3s/.*/set xlabel \"'$4'\"/' variable.plot
gnuplot variable.plot
