#!/bin/bash
DIR0="./runs/PC200_seed0_2911_132521"
DIR1="./runs/PC200_seed1_2911_134619"
DIR2="./runs/PC200_seed2_2911_153458"
DIR3="./runs/PC200_seed3_2911_160254"
DIR4="./runs/PC200_seed4_2911_163444"
DIR5="./runs/PC200_seed5_2911_165614"
DIR6="./runs/PC200_seed6"
# nh-run evaluate --run-dir $DIR0
# nh-run evaluate --run-dir $DIR1
# nh-run evaluate --run-dir $DIR2
# nh-run evaluate --run-dir $DIR3
# nh-run evaluate --run-dir $DIR4
# nh-run evaluate --run-dir $DIR5
nh-run evaluate --run-dir $DIR6
nh-results-ensemble --run-dirs $DIR0 $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 --output-dir ./runs/PC200_ensemble --metrics NSE MSE KGE

DIR0="./runs/PC100_seed0_2911_132118"
DIR1="./runs/PC100_seed1_2911_134215"
DIR2="./runs/PC100_seed2_2911_153053"
DIR3="./runs/PC100_seed3_2911_155203"
DIR4="./runs/PC100_seed4_2911_163033"
DIR5="./runs/PC100_seed5_2911_165201"
DIR6="./runs/PC100_seed6"
# nh-run evaluate --run-dir $DIR0
# nh-run evaluate --run-dir $DIR1
# nh-run evaluate --run-dir $DIR2
# nh-run evaluate --run-dir $DIR3
# nh-run evaluate --run-dir $DIR4
# nh-run evaluate --run-dir $DIR5
nh-run evaluate --run-dir $DIR6
nh-results-ensemble --run-dirs $DIR0 $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 --output-dir ./runs/PC100_ensemble --metrics NSE MSE KGE

DIR0="./runs/PC50_Attributes_seed0_2911_131704"
DIR1="./runs/PC50_Attributes_seed1_2911_133803"
DIR2="./runs/PC50_Attributes_seed2_2911_152642"
DIR3="./runs/PC50_Attributes_seed3_2911_154746"
DIR4="./runs/PC50_Attributes_seed4_2911_162620"
DIR5="./runs/PC50_Attributes_seed5_2911_164742"
DIR6="./runs/PC50_seed6"
# nh-run evaluate --run-dir $DIR0
# nh-run evaluate --run-dir $DIR1
# nh-run evaluate --run-dir $DIR2
# nh-run evaluate --run-dir $DIR3
# nh-run evaluate --run-dir $DIR4
# nh-run evaluate --run-dir $DIR5
nh-run evaluate --run-dir $DIR6
nh-results-ensemble --run-dirs $DIR0 $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 --output-dir ./runs/PC50_ensemble --metrics NSE MSE KGE

DIR0="./runs/PC20_seed0_2911_131254"
DIR1="./runs/PC20_seed1_2911_133355"
DIR2="./runs/PC20_seed2_2911_152230"
DIR3="./runs/PC20_seed3_2911_154333"
DIR4="./runs/PC20_seed4_2911_162203"
DIR5="./runs/PC20_seed5_2911_164328"
DIR6="./runs/PC20_seed6"
# nh-run evaluate --run-dir $DIR0
# nh-run evaluate --run-dir $DIR1
# nh-run evaluate --run-dir $DIR2
# nh-run evaluate --run-dir $DIR3
# nh-run evaluate --run-dir $DIR4
# nh-run evaluate --run-dir $DIR5
nh-run evaluate --run-dir $DIR6
nh-results-ensemble --run-dirs $DIR0 $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 --output-dir ./runs/PC20_ensemble --metrics NSE MSE KGE

DIR0="./runs/PC10_seed0_2911_130847"
DIR1="./runs/PC10_seed1_2911_132947"
DIR2="./runs/PC10_seed2_2911_151824"
DIR3="./runs/PC10_seed3_2911_153926"
DIR4="./runs/PC10_seed4_2911_161746"
DIR5="./runs/PC10_seed5_2911_163917"
DIR6="./runs/PC10_seed6"
# nh-run evaluate --run-dir $DIR0
# nh-run evaluate --run-dir $DIR1
# nh-run evaluate --run-dir $DIR2
# nh-run evaluate --run-dir $DIR3
# nh-run evaluate --run-dir $DIR4
# nh-run evaluate --run-dir $DIR5
nh-run evaluate --run-dir $DIR6
nh-results-ensemble --run-dirs $DIR0 $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 --output-dir ./runs/PC10_ensemble --metrics NSE MSE KGE