

#!/bin/bash

if [ -z $1 ] || [ -z $2 ] ; then
    echo "!!! please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target] [foundation]"
	exit
fi
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FLY_TARGET=$1
FOUNDATION=$2
PIPELINE_NAME="${FOUNDATION}-tas-platform"
PIPELINE_YAML="generated-pipeline-tas.yml"
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
## ytt from https://github.com/k14s/ytt/releases
$WORK_DIR/ytt template \
    -f $WORK_DIR/pipeline-template/pipeline-tas.yml \
    -f $WORK_DIR/pipeline-template/resource_types.lib.yml \
    -f $WORK_DIR/pipeline-template/common_resources.lib.yml \
    -f $WORK_DIR/pipeline-template/opsman_groups.lib.yml \
    -f $WORK_DIR/pipeline-template/opsman_resources.lib.yml \
    -f $WORK_DIR/pipeline-template/opsman_jobs.lib.yml \
    -f $WORK_DIR/pipeline-template/tas_products_groups.lib.yml \
    -f $WORK_DIR/pipeline-template/tas_products_resources.lib.yml \
    -f $WORK_DIR/pipeline-template/tas_products_jobs.lib.yml \
    --ignore-unknown-comments > $WORK_DIR/${PIPELINE_YAML}

fly -t ${FLY_TARGET} sp -p "${PIPELINE_NAME}" \
-c $WORK_DIR/${PIPELINE_YAML} \
-v foundation=${FOUNDATION} \
-v pipeline_name="${PIPELINE_NAME}"  \
-l $WORK_DIR/envs/${FOUNDATION}/pipeline-vars/params.yml
