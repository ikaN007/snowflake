#!/bin/bash

###################################
# Author: Shubham Saroj           #
# Creation Date: 18 Dec 2019      #
###################################

ls -larth Objectlist_qa.txt | awk '{ print $NF }' > full_bidw_file_listing.txt
ls -larth Objectlist_qa.txt | awk '{ print $NF }' > bidw_file_listing.txt

######################## Variable Declaration #################
actual_file_count=`ls -1 Objectlist_qa.txt | wc -l`
file_files_count=`cat bidw_file_listing.txt | grep "BIDW" | wc -l`
DB_NAME=TEST_QA

echo "The number of actual files to process are $actual_file_count"
echo "The number of file files to process are $file_files_count"


for search in `seq 1 "$file_files_count"`
do
awk 'NR == n' n="${search}" bidw_file_listing.txt > bidw_file_one_per_line.txt
awk 'NR == n' n="${search}" full_bidw_file_listing.txt > bidw_full_file_one_per_line.txt

###################### Accept each parameter as variable ###################

fqdn=`cat bidw_file_one_per_line.txt | awk -F "." '{ print $2"."$3 }'`
object=`cat bidw_file_one_per_line.txt | awk -F "." '{ print $(NF-1) }'`
schema=`cat bidw_file_one_per_line.txt | awk -F "." '{ print $2 }'`
filename=`cat bidw_full_file_one_per_line.txt`


#### Format for exection of command: echo "snowsql -f filename.sql -q USE DATABASE variable USE SCHEMA variable"

snowsql -f $filename -q USE DATABASE $DB_NAME USE SCHEMA $schema
done
