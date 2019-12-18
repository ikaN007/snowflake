#!/bin/bash
count=`cat Objectlist.txt | wc -l`
for rotate in `seq 1 "$count"`
do
awk 'NR == n' n="${rotate}" Objectlist.txt > oneline.txt
fqdn=`awk '{ print $1 }' oneline.txt`
objtype=`awk '{ print $2 }' oneline.txt`
snowsql -q "SELECT GET_DDL('$objtype','$fqdn')" | grep -v GET_DDL > BIDW.${fqdn}.${objtype}.sql; chmod a+x BIDW.${fqdn}.${objtype}.sql
done

ls -larth BIDW.*.sql | awk '{ print $NF }' > Objectlist_qa.txt
