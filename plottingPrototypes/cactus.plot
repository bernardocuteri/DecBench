set terminal png
set output "cactus_carkov.png"
set xlabel "Solved Instances"
set ylabel "Time (s)"
plot "clingo.dat" using 2:1 w lp ,"wasp.dat" using 2:1 w lp ,"wasp_comp.dat" using 2:1 w lp
