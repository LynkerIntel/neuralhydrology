#!/bin/bash

DIR1="./runs/HA_10random_Attributes_a_0711_222711"
DIR2="./runs/HA_10random_Attributes_a_seed1_0811_220021"
DIR3="./runs/HA_10random_Attributes_a_seed2_2311_081520"
DIR4="./runs/HA_10random_Attributes_a_seed3_2311_095221"
DIR5="./runs/HA_10random_Attributes_a_seed4_2311_124350"
DIR6="./runs/HA_10random_Attributes_a_seed5_2411_000749"
DIR7="./runs/HA_10random_Attributes_a_seed6_2511_091759"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/HA_10random_Attributes_a --metrics NSE MSE KGE

DIR1="./runs/HA_10random_Attributes_b_0711_223123"
DIR2="./runs/HA_10random_Attributes_b_seed1_0811_220427"
DIR3="./runs/HA_10random_Attributes_b_seed2_2311_081924"
DIR4="./runs/HA_10random_Attributes_b_seed3_2311_095625"
DIR5="./runs/HA_10random_Attributes_b_seed4_2311_124754"
DIR6="./runs/HA_10random_Attributes_b_seed5_2411_001155"
DIR7="./runs/HA_10random_Attributes_b_seed6_2511_092159"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/HA_10random_Attributes_b --metrics NSE MSE KGE

# DIR1="./runs/HA_10random_Attributes_c_0711_223533"
# DIR2="./runs/HA_10random_Attributes_c_seed1_0811_220833"
# nh-results-ensemble --run-dirs $DIR1 $DIR2 --output-dir ./runs/HA_10random_Attributes_c --metrics NSE MSE KGE

DIR1="./runs/HA_10random_Attributes_d_0711_223535"
DIR2="./runs/HA_10random_Attributes_d_seed1_0811_220835"
DIR3="./runs/HA_10random_Attributes_d_seed2_2311_082328"
DIR4="./runs/HA_10random_Attributes_d_seed3_2311_100031"
DIR5="./runs/HA_10random_Attributes_d_seed4_2311_125159"
DIR6="./runs/HA_10random_Attributes_d_seed5_2411_001559"
DIR7="./runs/HA_10random_Attributes_d_seed6_2511_092557"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/HA_10random_Attributes_d --metrics NSE MSE KGE

# DIR1="./runs/HA_10random_Attributes_e_0711_223946"
# DIR2="./runs/HA_10random_Attributes_e_seed1_0811_221242"
# nh-results-ensemble --run-dirs $DIR1 $DIR2 --output-dir ./runs/HA_10random_Attributes_e --metrics NSE MSE KGE

DIR1="./runs/HA_10random_Attributes_f_0711_223947"
DIR2="./runs/HA_10random_Attributes_f_seed1_0811_221243"
DIR3="./runs/HA_10random_Attributes_f_seed2_2311_082733"
DIR4="./runs/HA_10random_Attributes_f_seed3_2311_100442"
DIR5="./runs/HA_10random_Attributes_f_seed4_2311_125602"
DIR6="./runs/HA_10random_Attributes_f_seed5_2411_002000"
DIR7="./runs/HA_10random_Attributes_f_seed6_2511_092958"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/HA_10random_Attributes_f --metrics NSE MSE KGE

# DIR1="./runs/HA_10random_Attributes_g_0711_224357"
# DIR2="./runs/HA_10random_Attributes_g_seed1_0811_221647"
# nh-results-ensemble --run-dirs $DIR1 $DIR2 --output-dir ./runs/HA_10random_Attributes_g --metrics NSE MSE KGE

# DIR1="./runs/HA_10random_Attributes_h_0711_224359"
# DIR2="./runs/HA_10random_Attributes_h_seed1_0811_221649"
# nh-results-ensemble --run-dirs $DIR1 $DIR2 --output-dir ./runs/HA_10random_Attributes_h --metrics NSE MSE KGE

DIR1="./runs/HA_10random_Attributes_i_0711_224401"
DIR2="./runs/HA_10random_Attributes_i_seed1_0811_221651"
DIR3="./runs/HA_10random_Attributes_i_seed2_2311_083135"
DIR4="./runs/HA_10random_Attributes_i_seed3_2311_100849"
DIR5="./runs/HA_10random_Attributes_i_seed4_2311_130005"
DIR6="./runs/HA_10random_Attributes_i_seed5_2411_002401"
DIR7="./runs/HA_10random_Attributes_i_seed6_2511_093359"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/HA_10random_Attributes_i --metrics NSE MSE KGE

DIR1="./runs/NOAHMP_Attributes_0711_214556"
DIR2="./runs/NOAHMP_Attributes_seed1_0811_211909"
DIR3="./runs/NOAHMP_Attributes_seed2_2311_073422"
DIR4="./runs/NOAHMP_Attributes_seed3_2311_091141"
DIR5="./runs/NOAHMP_Attributes_seed4_2311_120348"
DIR6="./runs/NOAHMP_Attributes_seed5_2311_232723"
DIR7="./runs/NOAHMP_Attributes_seed6_2511_083737"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/NOAHMP_Attributes --metrics NSE MSE KGE

DIR1="./runs/PC1_Attributes_0711_214955"
DIR2="./runs/PC1_Attributes_seed1_0811_212309"
DIR3="./runs/PC1_Attributes_seed2_2311_073823"
DIR4="./runs/PC1_Attributes_seed3_2311_091534"
DIR5="./runs/PC1_Attributes_seed4_2311_120736"
DIR6="./runs/PC1_Attributes_seed5_2311_233118"
DIR7="./runs/PC1_Attributes_seed6_2511_084144"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/PC1_Attributes --metrics NSE MSE KGE

DIR1="./runs/PC2_Attributes_0711_215406"
DIR2="./runs/PC2_Attributes_seed1_0811_212720"
DIR3="./runs/PC2_Attributes_seed2_2311_074232"
DIR4="./runs/PC2_Attributes_seed3_2311_091943"
DIR5="./runs/PC2_Attributes_seed4_2311_121143"
DIR6="./runs/PC2_Attributes_seed5_2311_233528"
DIR7="./runs/PC2_Attributes_seed6_2511_084552"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/PC2_Attributes --metrics NSE MSE KGE

DIR1="./runs/PC3_Attributes_0711_215817"
DIR2="./runs/PC3_Attributes_seed1_0811_213133"
DIR3="./runs/PC3_Attributes_seed2_2311_074641"
DIR4="./runs/PC3_Attributes_seed3_2311_092349"
DIR5="./runs/PC3_Attributes_seed4_2311_121549"
DIR6="./runs/PC3_Attributes_seed5_2311_233937"
DIR7="./runs/PC3_Attributes_seed6_2511_084953"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/PC3_Attributes --metrics NSE MSE KGE

DIR1="./runs/PC4_Attributes_0711_220217"
DIR2="./runs/PC4_Attributes_seed1_0811_213532"
DIR3="./runs/PC4_Attributes_seed2_2311_075040"
DIR4="./runs/PC4_Attributes_seed3_2311_092746"
DIR5="./runs/PC4_Attributes_seed4_2311_121939"
DIR6="./runs/PC4_Attributes_seed5_2311_234330"
DIR7="./runs/PC4_Attributes_seed6_2511_085346"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/PC4_Attributes --metrics NSE MSE KGE

DIR1="./runs/PC5_Attributes_0711_220627"
DIR2="./runs/PC5_Attributes_seed1_0811_213942"
DIR3="./runs/PC5_Attributes_seed2_2311_075448"
DIR4="./runs/PC5_Attributes_seed3_2311_093151"
DIR5="./runs/PC5_Attributes_seed4_2311_122343"
DIR6="./runs/PC5_Attributes_seed5_2311_234736"
DIR7="./runs/PC5_Attributes_seed6_2511_085751"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/PC5_Attributes --metrics NSE MSE KGE

DIR1="./runs/PC6_Attributes_0711_221035"
DIR2="./runs/PC6_Attributes_seed1_0811_214354"
DIR3="./runs/PC6_Attributes_seed2_2311_075859"
DIR4="./runs/PC6_Attributes_seed3_2311_093603"
DIR5="./runs/PC6_Attributes_seed4_2311_122748"
DIR6="./runs/PC6_Attributes_seed5_2311_235143"
DIR7="./runs/PC6_Attributes_seed6_2511_090154"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/PC6_Attributes --metrics NSE MSE KGE

DIR1="./runs/PC7_Attributes_0711_221447"
DIR2="./runs/PC7_Attributes_seed1_0811_214804"
DIR3="./runs/PC7_Attributes_seed2_2311_080309"
DIR4="./runs/PC7_Attributes_seed3_2311_094014"
DIR5="./runs/PC7_Attributes_seed4_2311_123151"
DIR6="./runs/PC7_Attributes_seed5_2311_235546"
DIR7="./runs/PC7_Attributes_seed6_2511_090559"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/PC7_Attributes --metrics NSE MSE KGE

DIR1="./runs/PC8_Attributes_0711_221848"
DIR2="./runs/PC8_Attributes_seed1_0811_215202"
DIR3="./runs/PC8_Attributes_seed2_2311_080706"
DIR4="./runs/PC8_Attributes_seed3_2311_094410"
DIR5="./runs/PC8_Attributes_seed4_2311_123544"
DIR6="./runs/PC8_Attributes_seed5_2311_235940"
DIR7="./runs/PC8_Attributes_seed6_2511_090952"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/PC8_Attributes --metrics NSE MSE KGE

DIR1="./runs/PC9_Attributes_0711_222258"
DIR2="./runs/PC9_Attributes_seed1_0811_215613"
DIR3="./runs/PC9_Attributes_seed2_2311_081116"
DIR4="./runs/PC9_Attributes_seed3_2311_094816"
DIR5="./runs/PC9_Attributes_seed4_2311_123949"
DIR6="./runs/PC9_Attributes_seed5_2411_000346"
DIR7="./runs/PC9_Attributes_seed6_2511_091355"
nh-run evaluate --run-dir $DIR7
nh-results-ensemble --run-dirs $DIR1 $DIR2 $DIR3 $DIR4 $DIR5 $DIR6 $DIR7 --output-dir ./runs/PC9_Attributes --metrics NSE MSE KGE