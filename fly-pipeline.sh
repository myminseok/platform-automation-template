#!/bin/bash

if [ -z $1 ] || [ -z $2 ] ; then
    echo "!!! please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target] [foundation]"
	exit
fi


FLY_TARGET=$1
FOUNDATION=$2

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
GENERATED_DIR=${SCRIPT_DIR}/pipelines-generated/

fly -t ${FLY_TARGET} sp \
    -p ${FOUNDATION} \
	-c $GENERATED_DIR/merged-platform-pipeline.yml \
	-v foundation=${FOUNDATION} \
	-v product=$PRODUCT \
	-l $SCRIPT_DIR/foundations/${FOUNDATION}/vars/common-vars.yml
