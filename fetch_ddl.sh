#!/bin/bash
count=`cat /home/jenkins/agent/workspace/Snowflake_test_test_dev/Objectlist.txt | wc -l`
for rotate in `seq 1 "$count"`
do
awk 'NR == n' n="${rotate}" /home/jenkins/agent/workspace/Snowflake_test_test_dev/Objectlist.txt > /home/jenkins/agent/workspace/Snowflake_test_test_dev/oneline.txt
fqdn=`awk '{ print $1 }' /home/jenkins/agent/workspace/Snowflake_test_test_dev/oneline.txt`
objtype=`awk '{ print $2 }' /home/jenkins/agent/workspace/Snowflake_test_test_dev/oneline.txt`
snowsql -q "SELECT GET_DDL('$objtype','$fqdn')" | grep -v GET_DDL > /home/jenkins/agent/workspace/Snowflake_test_test_dev/BIDW.${fqdn}.${objtype}.sql; chmod a+x /home/jenkins/agent/workspace/Snowflake_test_test_dev/BIDW.${fqdn}.${objtype}.sql
done
