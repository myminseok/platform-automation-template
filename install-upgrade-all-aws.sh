#!/bin/bash

if [ -z $1 ]  ; then
    echo "please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target]"
	exit
fi	

FLY_TARGET=$1

fly -t ${FLY_TARGET} sp -p "${FLY_TARGET}-install-upgrade-all" \
-c ./install-upgrade-all-aws.yml \
-l ./${FLY_TARGET}/pipeline-vars/params.yml

## fly -t demo clear-task-cache 
