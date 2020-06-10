

#!/bin/bash

if [ -z $1 ] || [ -z $2 ] ; then
    echo "!!! please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target] [foundation]"
	exit
fi
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
FLY_TARGET=$1
FOUNDATION=$2
PIPELINE_NAME="${FOUNDATION}-pks-platform"
PIPELINE_YAML="generated-pipeline-pks.yml"
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## ytt from https://github.com/k14s/ytt/releases
$WORK_DIR/ytt template \
    -f $WORK_DIR/pipeline-templates/pipeline-pks.yml \
    -f $WORK_DIR/pipeline-templates/resource_types.lib.yml \
    -f $WORK_DIR/pipeline-templates/common_resources.lib.yml \
    -f $WORK_DIR/pipeline-templates/opsman_groups.lib.yml \
    -f $WORK_DIR/pipeline-templates/opsman_resources.lib.yml \
    -f $WORK_DIR/pipeline-templates/opsman_jobs.lib.yml \
    -f $WORK_DIR/pipeline-templates/pks_products_groups.lib.yml \
    -f $WORK_DIR/pipeline-templates/pks_products_resources.lib.yml \
    -f $WORK_DIR/pipeline-templates/pks_products_jobs.lib.yml \
    --ignore-unknown-comments > $WORK_DIR/${PIPELINE_YAML}

fly -t ${FLY_TARGET} sp -p "${PIPELINE_NAME}" \
-c $WORK_DIR/${PIPELINE_YAML} \
-v foundation=${FOUNDATION} \
-v pipeline_name="${PIPELINE_NAME}"  \
-l $WORK_DIR/foundations/${FOUNDATION}/pipeline-vars/params.yml
