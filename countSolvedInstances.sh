for d in $1/* ; do
    echo $d
    ls $d/*/refinedBenchmarks/ | wc -l
done
