#!/bin/bash

#!/bin/bash

# Function to run nh-run train with each configuration file
run_nh_train () {
    for letter in {a..i}; do
        nh-run train --config-file "./config_files/config_HA3random_$letter.yml"
    done
}

# Function to perform search and replace
search_replace_seed () {
    local old_seed=$1
    local new_seed=$2

    sed -i "s/seed$old_seed/seed$new_seed/g" ./config_files/config_HA3random_*.yml
    sed -i "s/seed: $old_seed/seed: $new_seed/g" ./config_files/config_HA3random_*.yml
}

# Run nh-run train with each configuration file (first pass)
run_nh_train

# Perform search and replace (seed0 to seed1)
search_replace_seed 0 1

# Run nh-run train with each configuration file (second pass)
run_nh_train

# Perform search and replace (seed1 to seed2)
search_replace_seed 1 2

#----------------------------------------------------------------------

# nh-run train --config-file ./config_files/config_HA3random_a.yml
# nh-run train --config-file ./config_files/config_HA3random_b.yml
# nh-run train --config-file ./config_files/config_HA3random_c.yml
# nh-run train --config-file ./config_files/config_HA3random_d.yml
# nh-run train --config-file ./config_files/config_HA3random_e.yml
# nh-run train --config-file ./config_files/config_HA3random_f.yml
# nh-run train --config-file ./config_files/config_HA3random_g.yml
# nh-run train --config-file ./config_files/config_HA3random_h.yml
# nh-run train --config-file ./config_files/config_HA3random_i.yml
# sed -i 's/seed0/seed1/g' ./config_files/config_HA3random_*.yml
# sed -i 's/seed: 0/seed: 1/g' ./config_files/config_HA3random_*.yml
# nh-run train --config-file ./config_files/config_HA3random_a.yml
# nh-run train --config-file ./config_files/config_HA3random_b.yml
# nh-run train --config-file ./config_files/config_HA3random_c.yml
# nh-run train --config-file ./config_files/config_HA3random_d.yml
# nh-run train --config-file ./config_files/config_HA3random_e.yml
# nh-run train --config-file ./config_files/config_HA3random_f.yml
# nh-run train --config-file ./config_files/config_HA3random_g.yml
# nh-run train --config-file ./config_files/config_HA3random_h.yml
# nh-run train --config-file ./config_files/config_HA3random_i.yml
# sed -i 's/seed1/seed2/g' ./config_files/config_HA3random_*.yml
# sed -i 's/seed: 1/seed: 2/g' ./config_files/config_HA3random_*.yml