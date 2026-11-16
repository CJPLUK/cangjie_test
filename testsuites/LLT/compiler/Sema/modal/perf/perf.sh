# Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
# This source file is part of the Cangjie project, licensed under Apache-2.0
# with Runtime Library Exception.
#
# See https://cangjie-lang.cn/pages/LICENSE for license information.
cd "$(dirname "$0")"

cjc -L${CANGJIE_STDX_PATH} --experimental --enable-local-mode --import-path=${CANGJIE_STDX_PATH} json-old.cj -lstdx.encoding.json -O2 --int-overflow=wrapping --no-sub-pkg -Woff all -o old
# printf "non local\n"
LD_LIBRARY_PATH="${CANGJIE_STDX_PATH}:${LD_LIBRARY_PATH}" ./old > old.t
cjc -L${CANGJIE_STDX_PATH} --experimental --enable-local-mode --import-path=${CANGJIE_STDX_PATH} json.cj -lstdx.encoding.json -O2 --int-overflow=wrapping --no-sub-pkg -Woff all -o main
# printf "\n\nlocal\n"
LD_LIBRARY_PATH="${CANGJIE_STDX_PATH}:${LD_LIBRARY_PATH}" ./main > local.t
# heap.dat: idx old local_col1 local_col2; 80 samples → 20 rounds × 4
paste -d' ' old.t local.t | nl -ba -w1 -s' ' > heap.dat
# Heap memory: old.t vs local.t (col1=heap, col2=heap+local).
# X: 20 rounds, each round is a group of 4 samples.
gnuplot <<'EOF'
set terminal pngcairo size 1600,700 enhanced font 'Sans,11'
set output 'heap.png'

set title 'Heap memory: old vs local (20 rounds × 4 samples)'
set xlabel 'Round'
set ylabel 'Heap (bytes)'
set key top left
set grid ytics
set style data linespoints
set pointsize 0.7

# Group centers at 2.5, 6.5, ..., 78.5 → labels 1..20
set xtics ( \
  "1" 2.5, "2" 6.5, "3" 10.5, "4" 14.5, "5" 18.5, \
  "6" 22.5, "7" 26.5, "8" 30.5, "9" 34.5, "10" 38.5, \
  "11" 42.5, "12" 46.5, "13" 50.5, "14" 54.5, "15" 58.5, \
  "16" 62.5, "17" 66.5, "18" 70.5, "19" 74.5, "20" 78.5 \
)
set xrange [0.5:80.5]
set format y '%.0s%c'

# Vertical separators between rounds (every 4 samples)
set for [i=1:19] arrow from 4*i+0.5, graph 0 to 4*i+0.5, graph 1 nohead lc rgb '#cccccc' lw 1

plot 'heap.dat' using 1:2 with linespoints lc rgb '#d62728' lw 1.5 pt 7 title 'old', \
     'heap.dat' using 1:3 with linespoints lc rgb '#2ca02c' lw 1.5 pt 7 title 'local (heap)', \
     'heap.dat' using 1:4 with linespoints lc rgb '#1f77b4' lw 1.5 pt 7 title 'local (heap+local)'
EOF
