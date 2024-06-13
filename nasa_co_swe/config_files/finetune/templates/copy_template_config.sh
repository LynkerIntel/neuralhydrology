#!/bin/bash

# Base run dir from pre-training
basin_run_dir='pretrain_hs128_lossMSE_lr1e-3down_HA_snotel_seed4_1206_115051'

# Main project directory within NH dir
#main_proj_dir='/Users/joshsturtevant/Documents/lynker/projects/nasa_water/neuralhydrology/nasa_co_swe/'
main_proj_dir='../../../'

# Output for run script
run_script="$main_proj_dir/job_scripts/finetune/finetune_models_ensemble_swe_snotel_noswe.sh"

# Define your lists
co_basins=("06614800" "06746095" "07083000" "09034900" "09035800" "09035900" "09047700" "09065500" "09066000" "09066200" "09066300" "09081600" "09107000" "09306242" "09352900")
snow_prod_idx=("0" "1" "2")

# Path to your template file
template_swe_snotel="template_swe_snotel.yml"
template_swe_ua="template_swe_ua.yml"
template_noSWE="template_noSWE.yml"

# Start the run script with the shebang line
echo "#!/bin/bash" > "$run_script"

# Loop through the lists and replace placeholders
for co_basin_i in "${co_basins[@]}"; do
    for snow_prod_i in "${snow_prod_idx[@]}"; do

        # Create a new file name based on the list items
        output_file_swe_snotel="${co_basin_i}_swe_snotel_${snow_prod_i}.yml"
        output_file_swe_ua="${co_basin_i}_swe_ua_${snow_prod_i}.yml"
        output_file_noSWE="${co_basin_i}_noSWE_${snow_prod_i}.yml"

        # Replace the placeholders and write to the new file
        sed -e "s/XBASINIDX/${co_basin_i}/g" -e "s/XSEEDX/${snow_prod_i}/g" -e "s/XBASE_RUN_DIRX/$basin_run_dir/g" "$template_swe_snotel" > "../leave_one_out/$output_file_swe_snotel"
        sed -e "s/XBASINIDX/${co_basin_i}/g" -e "s/XSEEDX/${snow_prod_i}/g" -e "s/XBASE_RUN_DIRX/$basin_run_dir/g" "$template_swe_ua" > "../leave_one_out/$output_file_swe_ua"
        sed -e "s/XBASINIDX/${co_basin_i}/g" -e "s/XSEEDX/${snow_prod_i}/g" -e "s/XBASE_RUN_DIRX/$basin_run_dir/g" "$template_noSWE" > "../leave_one_out/$output_file_noSWE"

        # print statements
        echo "Generated file: $output_file_swe_snotel"
        echo "Generated file: $output_file_swe_ua"
        echo "Generated file: $output_file_noSWE"

        ## Add run command for each configuration to the run script
        #echo "nh-run train --config-file ./config_files/finetune/leave_one_out/${output_file_swe_snotel}" >> "$run_script"
        #echo "nh-run train --config-file ./config_files/finetune/leave_one_out/${output_file_swe_ua}" >> "$run_script"
        #echo "nh-run train --config-file ./config_files/finetune/leave_one_out/${output_file_noSWE}" >> "$run_script"

        # Add run command for each configuration to the run script
        echo "nh-run finetune --config-file ../../config_files/finetune/leave_one_out/${output_file_swe_snotel}" >> "$run_script"
        echo "nh-run finetune --config-file ../../config_files/finetune/leave_one_out/${output_file_swe_ua}" >> "$run_script"
        echo "nh-run finetune --config-file ../../config_files/finetune/leave_one_out/${output_file_noSWE}" >> "$run_script"
    done
done

# Make the run script executable
chmod +x "$run_script"

echo "Generated run script: $run_script"