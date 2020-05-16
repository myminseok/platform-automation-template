#!/bin/bash

if [ -z $1 ] ; then
    echo "!!! please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target]"
	exit
fi	
FLY_TARGET=$1

fly -t ${FLY_TARGET} sp -p test-resources -c ./test-resources.yml \
-l ../platform-automation-configuration/${FLY_TARGET}/pipeline-vars/params.yml 
