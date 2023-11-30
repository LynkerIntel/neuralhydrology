#!/bin/bash

#!/bin/bash

# Function to run nh-run train with each configuration file
run_nh_train () {
    for letter in 10 20 50 100 200; do
        nh-run train --config-file "./config_files/config_PC$letter.yml"
    done
}

# Function to perform search and replace
search_replace_seed () {
    local old_seed=$1
    local new_seed=$2

    sed -i "s/seed$old_seed/seed$new_seed/g" ./config_files/config_PC*.yml
    sed -i "s/seed: $old_seed/seed: $new_seed/g" ./config_files/config_PC*.yml
}

search_replace_seed 1 2
run_nh_train
search_replace_seed 2 3
run_nh_train
search_replace_seed 3 4
run_nh_train
search_replace_seed 4 5
run_nh_train
