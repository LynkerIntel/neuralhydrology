#!/bin/bash

# Path to the directory containing the files you want to search
SEARCH_DIR="./config_files"

# File containing the list of strings, located in a different directory
LIST_FILE="../data/CAMELS_US/hydroATLAS/hydroATLAS_Camels/list_of_missing_attributes.txt"

# Loop through each line in the list file
while IFS= read -r line
do
    echo "Searching for: $line"
    
    # Use find and grep to search for the line in specific files within SEARCH_DIR
    find "$SEARCH_DIR" -name "config_HA3random_*.yml" -exec grep -l "$line" {} +

    echo "-----------------------------------"
done < "$LIST_FILE"
