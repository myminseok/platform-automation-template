#!/bin/bash

if [ -z $1 ] ; then
    echo "please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target]"
	exit
fi	
FLY_TARGET=$1


fly -t ${FLY_TARGET} sp -p "download-product" \
-c ./download-product.yml \
-l ../platform-automation-configuration-jumpbox/${FLY_TARGET}/pipeline-vars/common-params.yml \
-v foundation=${FLY_TARGET}
