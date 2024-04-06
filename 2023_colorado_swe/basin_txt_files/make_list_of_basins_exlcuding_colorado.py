#!/home/jonat/anaconda3/envs/nh_cuda/bin/python

co_basins_path = "./co_basins.txt"  # Path to co_basins.txt
list_671_camels_basins_path = "/mnt/d/nh/CAMELS_US/list_671_camels_basins.txt"  # Path to list_671_camels_basins.txt
output_path = "excluding_co_camels_basins.txt"  # Path for the output file

# Read in the content of both files
with open(co_basins_path, 'r') as file:
    co_basins = set(file.read().splitlines())

with open(list_671_camels_basins_path, 'r') as file:
    list_671_camels_basins = set(file.read().splitlines())

# Find the difference between the two sets
exclusive_basins = list_671_camels_basins - co_basins

# Write the exclusive basins to a new file
with open(output_path, 'w') as file:
    for basin in sorted(exclusive_basins):
        file.write(f"{basin}\n")

print(f"Exclusive basins list saved to {output_path}.")
