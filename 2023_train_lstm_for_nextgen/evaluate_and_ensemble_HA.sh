#!/bin/bash
DIR0="./runs/HA_seed0_2811_165025"
DIR1="./runs/HA_seed1_2811_165457"
DIR2="./runs/HA_seed2_2811_165927"
DIR3="./runs/HA_seed3_2811_170356"
DIR4="./runs/HA_seed4_2811_170824"
DIR5="./runs/HA_seed5_2811_171250"
DIR6="./runs/HA_seed6_2811_171720"
# nh-run evaluate --run-dir $DIR0
# nh-run evaluate --run-dir $DIR1
# nh-run evaluate --run-dir $DIR2
# nh-run evaluate --run-dir $DIR3
# nh-run evaluate --run-dir $DIR4
# nh-run evaluate --run-dir $DIR5
# nh-run evaluate --run-dir $DIR6
nh-results-ensemble --run-dirs $DIR0 $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 --output-dir ./runs/HA_all_ensemble --metrics NSE MSE KGE