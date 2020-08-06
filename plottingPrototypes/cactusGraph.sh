if (($# < 2))
then
    echo "Folder and domain arguments neededd";
    exit 1;
fi
PLOTFILE=cactus.plot
./getCactusGraph.pl $1 $2 > $PLOTFILE
gnuplot $PLOTFILE
