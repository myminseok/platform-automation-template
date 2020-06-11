#!/bin/bash -e

if [ ! $# -eq 1 ] ; then
    echo "${BASH_SOURCE[0]} FOUNDATION"
    exit
fi  

FOUNDATION=$1
product=opsman

SCRIPT_NAME=$(basename ${BASH_SOURCE[0]})
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
foundation_config_path="$WORK_DIR/../foundations/${FOUNDATION}"
config_path="$foundation_config_path/opsman"
config_file=$config_path/${product}.yml
generated_product_template_vars_path="$foundation_config_path/generated-vars"
var_file=${generated_product_template_vars_path}/${product}.yml

if [ ! -f ${config_file} ]; then
  echo "Prepare ${product} config file first under ${config_file}"
  exit 1
fi

mkdir -p ${generated_product_template_vars_path}
echo "Following values will OVERWRITE to ${var_file}"
echo ""
grep -r '(('  ${config_file} |  awk '{print $3}' | sed 's/((//g' | sed 's/))/:/g'
echo ""
read -p "Are you sure to OVERWRITE ? (Yy) " -n 1 -r
if [[ ! $REPLY =~  ^[Yy]$ ]]
then
	exit 0
fi


grep -r '(('  ${config_file} |  awk '{print $3}' | sed 's/((//g' | sed 's/))/:/g' \
> ${var_file}
echo "Generated ${var_file}"
