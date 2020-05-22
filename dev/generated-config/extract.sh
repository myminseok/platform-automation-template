#!/bin/bash

grep "((" ./director.yml | awk -F':' '{print $2 $1}' | sed 's/((//g' | sed 's/))//g' > director.yml.items

echo "" >director.yml.credhub
while read -r line;
do
    crehubkey=`echo $line | awk '{print $1}'`
    origingalkey=`echo $line | awk '{print $2}'`
    echo "${crehubkey}: ''" >> director.yml.credhub

done < './director.yml.items'
