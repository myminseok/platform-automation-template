#!/bin/bash


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PIPELINES_DIR=${SCRIPT_DIR}/pipelines-templates
GENERATED_DIR=${SCRIPT_DIR}/pipelines-generated




function generate_product_pipeline() {

  local PRODUCT=$1
	fly  vp \
	-c $PIPELINES_DIR/product-pipeline-template.yml \
	-v foundation="((foundation))"\
	-v product=$PRODUCT \
	-l ${PIPELINES_DIR}/common-vars-for-pipeline-generation.yml \
	-o > ${GENERATED_DIR}/generated-${PRODUCT}.yml
  echo "product pipeline generated ${GENERATED_DIR}/${PRODUCT}-generated.yml"
}

rm -rf ${GENERATED_DIR}
mkdir -p ${GENERATED_DIR}

generate_product_pipeline "tas"
generate_product_pipeline "healthwatch2"
generate_product_pipeline "healthwatch2-pas-exporter"

