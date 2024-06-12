#!/bin/bash

# Define your lists
list1=("06614800" "06746095" "07083000" "09034900" "09035800" "09035900" "09047700" "09065500" "09066000" "09066200" "09066300" "09081600" "09107000" "09306242" "09352900")
list2=("0" "1" "2")

# Path to your template file
template_swe_snotel="template_swe_snotel.yml"
template_swe_ua="template_swe_ua.yml"
template_noSWE="template_noSWE.yml"
out_dir='../leave_one_out/'

# File to store run commands
run_script="../../../job_scripts/finetune_models_ensemble_swe_snotel_noswe.sh"

# Base run dir from pre-trainign
basin_run_dir='pretrain_hs128_lossMSE_lr1e-3down_HA_snotel_seed4_1206_115051'

# Start the run script with the shebang line
echo "#!/bin/bash" > "$run_script"

# Loop through the lists and replace placeholders
for item1 in "${list1[@]}"; do
    for item2 in "${list2[@]}"; do

        # Create a new file name based on the list items
        output_file_swe_snotel="${item1}_swe_snotel_${item2}.yml"
        output_file_swe_ua="${item1}_swe_ua_${item2}.yml"
        output_file_noSWE="${item1}_noSWE_${item2}.yml"

        # Replace the placeholders and write to the new file
        sed -e "s/XBASINIDX/${item1}/g" -e "s/XSEEDX/${item2}/g" -e "s/XBASE_RUN_DIRX/$basin_run_dir/g" "$template_swe_snotel" > "$out_dir/$output_file_swe_snotel"
        sed -e "s/XBASINIDX/${item1}/g" -e "s/XSEEDX/${item2}/g" -e "s/XBASE_RUN_DIRX/$basin_run_dir/g" "$template_swe_ua" > "$out_dir/$output_file_swe_ua"
        sed -e "s/XBASINIDX/${item1}/g" -e "s/XSEEDX/${item2}/g" -e "s/XBASE_RUN_DIRX/$basin_run_dir/g" "$template_noSWE" > "$out_dir/$output_file_noSWE"

        # print statements
        echo "Generated file: $output_file_swe_snotel"
        echo "Generated file: $output_file_swe_ua"
        echo "Generated file: $output_file_noSWE"

        ## Add run command for each configuration to the run script
        #echo "nh-run train --config-file ./config_files/finetune/leave_one_out/${output_file_swe_snotel}" >> "$run_script"
        #echo "nh-run train --config-file ./config_files/finetune/leave_one_out/${output_file_swe_ua}" >> "$run_script"
        #echo "nh-run train --config-file ./config_files/finetune/leave_one_out/${output_file_noSWE}" >> "$run_script"

        # Add run command for each configuration to the run script
        echo "nh-run finetune --config-file ./config_files/finetune/leave_one_out/${output_file_swe_snotel}" >> "$run_script"
        echo "nh-run finetune --config-file ./config_files/finetune/leave_one_out/${output_file_swe_ua}" >> "$run_script"
        echo "nh-run finetune --config-file ./config_files/finetune/leave_one_out/${output_file_noSWE}" >> "$run_script"
    done
done

# Make the run script executable
chmod +x "$run_script"

echo "Generated run script: $run_script"