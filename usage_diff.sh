#!/bin/bash

# This is a script that calculates the usage difference (in bytes) between two different dates

# Get the two different dates (dirs) as inputs
dir1=$1
dir2=$2

# Create a directory to save the difference
outdir=${dir1}_vs_${dir2}
mkdir $outdir
cd $outdir

# Create the file with the usage difference
join -1 1 -2 1 <(sort $dir1/ordered_usage_per_user.txt) <(sort $dir2/ordered_usage_per_user.txt) | awk '{print $0,$2-$3}' | awk '{if ($4!=0) {print $0}}' | sort -k4nr > usage_difference.txt
