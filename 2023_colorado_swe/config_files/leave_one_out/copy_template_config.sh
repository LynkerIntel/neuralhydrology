#!/bin/bash

# Define your lists
list1=("06614800" "06746095" "07083000" "09034900" "09035800" "09035900" "09047700" "09065500" "09066000" "09066200" "09066300" "09081600" "09107000" "09306242" "09352900")
list2=("0" "1" "2")

# Path to your template file
template_withSWE="template_withSWE.yml"
template_noSWE="template_noSWE.yml"

# Loop through the lists and replace placeholders
for item1 in "${list1[@]}"; do
    for item2 in "${list2[@]}"; do

        # Create a new file name based on the list items
        output_file_withSWE="${item1}_withSWE_${item2}.yml"
        output_file_noSWE="${item1}_noSWE_${item2}.yml"

        # Replace the placeholders and write to the new file
        sed -e "s/XBASINIDX/${item1}/g" -e "s/XSEEDX/${item2}/g" "$template_withSWE" > "$output_file_withSWE"
        sed -e "s/XBASINIDX/${item1}/g" -e "s/XSEEDX/${item2}/g" "$template_noSWE" > "$output_file_noSWE"

        echo "Generated file: $output_file"
    done
done
