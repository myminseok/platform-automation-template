#!/bin/bash

if [ -z $1 ] || [ -z $2 ] ; then
    echo "please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target] [product-name]"
    echo "for product-name, see https://github.com/brightzheng100/platform-automation-pipelines/blob/master/vars-dev/vars-products.yml"
	exit
fi	

FLY_TARGET=$1	
PRODUCT_NAME=$2

fly -t ${FLY_TARGET} sp -p "${FLY_TARGET}-${PRODUCT_NAME}-install-upgrade" \
-c ./install-upgrade-product.yml \
-l ../platform-automation-configuration-jumpbox/${FLY_TARGET}/pipeline-vars/common-params.yml \
-v foundation=${FLY_TARGET} \
-v product-name=${PRODUCT_NAME}


## fly -t demo dp -p pcfdemo-cf-install-upgrade
## fly -t demo clear-task-cache -j pcfdemo-cf-install-upgrade/upload-and-stage-product -s download-product-from-s3


