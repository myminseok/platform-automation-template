#!/bin/bash

if [ -z $1 ] ||  [ -z $2 ] ; then
    echo "!!! please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target] FOUNDATION"
	exit
fi	
FLY_TARGET=$1
FOUNDATION=$2

fly -t ${FLY_TARGET} sp -p test-resources -c ./test-resources.yml \
-v foundation=${FOUNDATION} \
-l ../envs/${FOUNDATION}/pipeline-vars/params.yml
