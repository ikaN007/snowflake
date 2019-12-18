#!/bin/bash

###################################
# Author: Shubham Saroj           #
# Creation Date: 18 Dec 2019      #
###################################

cat /home/jenkins/agent/workspace/Snowflake_test_qa/Objectlist_qa.txt | awk '{ print $NF }' > /home/jenkins/agent/workspace/Snowflake_test_qa/full_bidw_file_listing.txt
cat /home/jenkins/agent/workspace/Snowflake_test_qa/Objectlist_qa.txt | awk '{ print $NF }' > /home/jenkins/agent/workspace/Snowflake_test_qa/bidw_file_listing.txt
cat /home/jenkins/agent/workspace/Snowflake_test_qa/Objectlist_qa.txt
######################## Variable Declaration #################
actual_file_count=`ls -1 /home/jenkins/agent/workspace/Snowflake_test_qa/full_bidw_file_listing.txt | wc -l`
file_files_count=`cat /home/jenkins/agent/workspace/Snowflake_test_qa/bidw_file_listing.txt | grep "BIDW" | wc -l`
DB_NAME=TEST_QA

echo "The number of actual files to process are $actual_file_count"
echo "The number of file files to process are $file_files_count"


for search in `seq 1 "$file_files_count"`
do
awk 'NR == n' n="${search}" /home/jenkins/agent/workspace/Snowflake_test_qa/bidw_file_listing.txt > /home/jenkins/agent/workspace/Snowflake_test_qa/bidw_file_one_per_line.txt
awk 'NR == n' n="${search}" /home/jenkins/agent/workspace/Snowflake_test_qa/full_bidw_file_listing.txt > /home/jenkins/agent/workspace/Snowflake_test_qa/bidw_full_file_one_per_line.txt

###################### Accept each parameter as variable ###################

fqdn=`cat /home/jenkins/agent/workspace/Snowflake_test_qa/bidw_file_one_per_line.txt | awk -F "." '{ print $2"."$3 }'`
object=`cat /home/jenkins/agent/workspace/Snowflake_test_qa/bidw_file_one_per_line.txt | awk -F "." '{ print $(NF-1) }'`
schema=`cat /home/jenkins/agent/workspace/Snowflake_test_qa/bidw_file_one_per_line.txt | awk -F "." '{ print $2 }'`
filename=`cat /home/jenkins/agent/workspace/Snowflake_test_qa/bidw_full_file_one_per_line.txt`


#### Format for exection of command: echo "snowsql -f filename.sql -q USE DATABASE variable USE SCHEMA variable"

snowsql -f $filename -d '$DB_NAME' -s '$schema'
done
