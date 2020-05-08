#!/bin/bash

if [ -z $1 ]  ; then
    echo "please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target]"
	exit
fi	

FLY_TARGET=$1	
PRODUCT_NAME=$2

fly -t ${FLY_TARGET} sp -p "${FLY_TARGET}-install-upgrade-all-awstest" \
-c ./install-upgrade-all-aws.yml \
-l ./configs/aws/pipeline-vars/params.yml \
-l ./configs/aws/pipeline-vars/secrets.yml

## fly -t demo clear-task-cache 
