#!/bin/bash -e
if [ ! $# -eq 2 ] ; then
    echo "${BASH_SOURCE[0]} FOUNDATION PRODUCT"
    exit
fi  

FOUNDATION=$1
PRODUCT=$2

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## TODO will not use IAAS at the moment
#foundation_config_path="$WORK_DIR/../${IAAS}/${FOUNDATION}"
foundation_config_path="$WORK_DIR/../${FOUNDATION}"

generated_product_template_path="$foundation_config_path/generated-products"
generated_product_template_vars_path="$foundation_config_path/generated-vars"

echo "Validating configuration for product $PRODUCT"

deploy_type="tile"
if [ "${PRODUCT}" == "os-conf" ]; then
  deploy_type="runtime-config"
fi

vars_files_args=("")
if [[ "${deploy_type}" == "runtime-config" ]]; then
  vars_files_args+=("--vars-file $foundation_config_path/versions/${PRODUCT}.yml")
fi

if [ -f "$foundation_config_path/vars/${PRODUCT}.yml" ]; then
  vars_files_args+=("--vars-file $foundation_config_path/vars/${PRODUCT}.yml")
fi

if [ "${deploy_type}" == "tile" ]; then
  bosh int --var-errs-unused $generated_product_template_path/${PRODUCT}.yml ${vars_files_args[@]} > /dev/null
fi

if [ -f "$generated_product_template_vars_path/${PRODUCT}.yml" ]; then
  vars_files_args+=("--vars-file $generated_product_template_vars_path/${PRODUCT}.yml")
fi

echo "bosh int --var-errs $generated_product_template_path/${PRODUCT}.yml ${vars_files_args[@]} > /dev/null"
bosh int --var-errs $generated_product_template_path/${PRODUCT}.yml ${vars_files_args[@]} > /dev/null
