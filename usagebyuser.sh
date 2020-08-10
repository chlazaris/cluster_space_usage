#!/bin/bash

# Script that get as input the index file and the list of unique users
# and calculates how much space each one of them occupies

# Get the inputs
unique_users=$1
index_file=$2

# Get usage information for each one of the users
for USER in `cat $unique_users`
do
	USAGE=`cat $index_file | grep " $USER " | awk '{print $5}' | paste -s -d+ - | bc`
	echo -e "$USER\t$USAGE" >> usage_per_user.txt
done

# Order based on who is using the most space
cat usage_per_user.txt | sort -k2,2nr > ordered_usage_per_user.txt
