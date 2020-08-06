if (($# < 1))
then
    echo "Benchmark folder needed";
    exit 1;
fi
PLOTFILE=cactus.plot
for domain in `find $1 -maxdepth 2 -mindepth 2 -type d -printf '%f\n'`;
do
    ./getCactusGraph.pl $1 $domain > $PLOTFILE;
    gnuplot $PLOTFILE
done

