#!/bin/bash

if [ -z $1  ] ; then
    echo "please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target]"
	exit
fi	
FLY_TARGET=$1

fly -t ${FLY_TARGET} sp -p "${FLY_TARGET}-opsman-install-upgrade" \
-c ./install-upgrade-opsman.yml \
-l ../platform-automation-configuration-jumpbox/${FLY_TARGET}/pipeline-vars/common-params.yml \
-v foundation=${FLY_TARGET}


## fly -t demo dp -p dev-opsman-install-upgrade
## fly -t demo clear-task-cache -j dev-opsman-install-upgrade/create-new-opsman-vm -s download-product-from-s3
## fly -t demo clear-task-cache -j dev-opsman-install-upgrade/upgrade-opsman-vm -s download-product-from-s3


