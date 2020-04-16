#!/bin/bash

if [ -z $1 ] ; then
    echo "please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target]"
	exit
fi	
FLY_TARGET=$1

fly -t ${FLY_TARGET} sp -p "${FLY_TARGET}-extract-staged-config" \
-c ./extract-staged-config.yml \
-l ../platform-automation-configuration-jumpbox/${FLY_TARGET}/pipeline-vars/common-params.yml \
-v foundation=${FLY_TARGET}

