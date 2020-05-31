#!/bin/bash -e

if [ ! $# -eq 1 ] ; then
    echo "${BASH_SOURCE[0]} FOUNDATION"
    exit
fi  

export FOUNDATION=$1


SCRIPT_NAME=$(basename ${BASH_SOURCE[0]})
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## TODO will not use IAAS at the moment
#foundation_config_path="$WORK_DIR/../${IAAS}/${FOUNDATION}"
foundation_config_path="$WORK_DIR/../${FOUNDATION}"
opsman_config_path="$foundation_config_path/opsman"



opsman_config_file=$opsman_config_path/opsman.yml
if [ ! -f ${opsman_config_file} ]; then
  echo "Prepare director config file first under ${opsman_config_file}"
  exit 1
fi
generated_product_template_vars_path="$foundation_config_path/generated-vars"
mkdir -p $generated_product_template_vars_path
grep -r '((' $opsman_config_file |  awk '{print $3}' | sed 's/((//g' | sed 's/))/:/g' \
> $generated_product_template_vars_path/opsman.yml
echo "Generatinged $generated_product_template_vars_path/opsman.yml"


director_config_file=$opsman_config_path/director.yml
if [ ! -f ${director_config_file} ]; then
  echo "Prepare director config file first under ${director_config_file}"
  exit 1
fi
generated_product_template_vars_path="$foundation_config_path/generated-vars"
mkdir -p $generated_product_template_vars_path
grep -r '((' $director_config_file |  awk '{print $3}' | sed 's/((//g' | sed 's/))/:/g' \
> $generated_product_template_vars_path/director.yml
echo "Generatinged $generated_product_template_vars_path/director.yml"