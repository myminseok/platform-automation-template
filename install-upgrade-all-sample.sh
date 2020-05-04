#!/bin/bash

if [ -z $1 ] ; then
    echo "please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target]"
	exit
fi	

FLY_TARGET=$1	
PRODUCT_NAME=$2

fly -t ${FLY_TARGET} sp -p "${FLY_TARGET}-install-upgrade-all" \
-c ./install-upgrade-all-sample.yml \
-l ./configs/${FLY_TARGET}/pipeline-vars/params.yml


## fly -t demo dp -p pcfdemo-cf-install-upgrade
## fly -t demo clear-task-cache -j pcfdemo-cf-install-upgrade/upload-and-stage-product -s download-product-from-s3


