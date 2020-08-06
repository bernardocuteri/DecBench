set terminal png
set output "three_sat_clauses_lazy.png"
set xlabel "clauses"
set ylabel "Tempo (s)"
plot "aggregated.dat" using 1:2 w lp
