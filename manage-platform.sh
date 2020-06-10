

#!/bin/bash

if [ -z $1 ] || [ -z $2 ] ; then
    echo "!!! please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target] [foundation]"
	exit
fi	
FLY_TARGET=$1
FOUNDATION=$2


## https://github.com/k14s/ytt/releases
./ytt template \
    -f pipeline-template/pipeline-tas.yml \
    -f pipeline-template/resource_types.lib.yml \
    -f pipeline-template/common_resources.lib.yml \
    -f pipeline-template/opsman_resources.lib.yml \
    -f pipeline-template/opsman_jobs.lib.yml \
    -f pipeline-template/tas_products_resources.lib.yml \
    -f pipeline-template/tas_products_jobs.lib.yml \
    --ignore-unknown-comments > ./pipeline-tas-generated.yml

fly -t ${FLY_TARGET} sp -p "${FOUNDATION}-manage-platform" \
-c ./pipeline-tas-generated.yml \
-v foundation=${FOUNDATION} \
-v BUILD_PIPELINE_NAME="${FOUNDATION}-manage-platform"  \
-l ./envs/${FOUNDATION}/pipeline-vars/params.yml
