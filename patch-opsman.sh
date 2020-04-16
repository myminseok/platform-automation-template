#!/bin/bash

if [ -z $1 ] ; then
    echo "please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target] [foundation]"
	exit
fi	

FLY_TARGET=$1	

fly -t ${FLY_TARGET} sp -p "${FLY_TARGET}-opsman-patch" \
-c ./patch-opsman.yml \
-l ../platform-automation-configuration-jumpbox/${FLY_TARGET}/pipeline-vars/common-params.yml \
-v foundation=${FLY_TARGET}


## fly -t demo dp -p pcfdemo-opsman-patch
## fly -t demo clear-task-cache -j pcfdemo-opsman-patch/replace-opsman-vm -s download-product-from-s3


