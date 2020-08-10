#!/bin/bash

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "This script calculates and sorts cluster space usage per user"
   echo "Syntax: calc_user_space INPUT_DIRECTORY"
}

################################################################################
# MAIN PROGRAM
################################################################################

# Get the options
while getopts ":h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
   esac
done

# This is a script the gives the list of users and the files in certain directory
# Give the full path to the directory of interest
source_dir=$1
script_dir="/lab/solexa_young/lazaris/code/space_usage"

# Get into the directory where all the results for storage monitoring will be stored
cd /lab/solexa_young/lazaris/space_usage/archived_snapshots/

# Get the date in the right format
day=$(date +'%Y%m%d')

# Create a directory with the current date in order to store the results
if [ -d "$day" ]; then
	# Exit if the directory exists
	echo "The directory ${day} already exists..."
	exit 1
else
	# Create the directory
	mkdir $day
fi

# Move into the new directory
cd $day

# Find the users and the files they own
find $source_dir -type d -name .snapshot -prune -o -type f -exec ls -al {} \; > younglab_users.txt

# Find the unique user IDs
cut -d' ' -f3 younglab_users.txt | sort | uniq > younglab_user_IDs.txt

# Run the script to calculate usage per user
$script_dir/usagebyuser.sh younglab_user_IDs.txt younglab_users.txt

# Calculate total space, space occupied and space left (in GB)
df -BG $source_dir | sed 1d | awk '{print $2}' | sed 's/G//' > total_disk_space_in_GB.txt
df -BG $source_dir | sed 1d | awk '{print $3}' | sed 's/G//' > used_disk_space_in_GB.txt
df -BG $source_dir | sed 1d | awk '{print $4}' | sed 's/G//' > free_disk_space_in_GB.txt
