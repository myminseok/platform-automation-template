#!/bin/bash

if [ -z $1 ] ; then
    echo "!!! please provide parameters"
	echo "${BASH_SOURCE[0]} [PIPELINE-NAME]"
	exit
fi	

source login-credhub.sh

CONCOURSE_PREFIX='/concourse/main'
PIPELINE_NAME=$1

credhub find | grep $PIPELINE_NAME | awk '{print $3}' > ./tmp-credhub-to-delete
cat './tmp-credhub-to-delete'

read -p "Are you sure? " -n 1 -r
if [[ ! $REPLY =~  ^[Yy]$ ]]
then
        rm -rf ./tmp-credhub-to-delete
	exit 0
fi

echo "\ndeleting"
while read -r line ;
do
 echo $line;
 credhub delete -n $line;
done <'./tmp-credhub-to-delete'
rm -rf ./tmp-credhub-to-delete
echo "deleted"

