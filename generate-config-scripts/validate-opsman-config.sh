#!/bin/bash -e
if [ ! $# -eq 1 ] ; then
    echo "${BASH_SOURCE[0]} FOUNDATION"
    exit
fi  

FOUNDATION=$1

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
## TODO will not use IAAS at the moment
#foundation_config_path="$WORK_DIR/../${IAAS}/${FOUNDATION}"
foundation_config_path="$WORK_DIR/../envs/${FOUNDATION}"

echo "Validating configuration for opsman $foundation_config_path/opsman/opsman.yml"
touch $foundation_config_path/vars/opsman.yml
echo "bosh int --var-errs --var-errs-unused $foundation_config_path/opsman/opsman.yml \
  --vars-file $foundation_config_path/vars/opsman.yml"
bosh int --var-errs --var-errs-unused $foundation_config_path/opsman/opsman.yml \
  --vars-file $foundation_config_path/vars/opsman.yml

echo "Validating configuration for director"
touch $foundation_config_path/vars/director.yml
echo "bosh int --var-errs --var-errs-unused $foundation_config_path/opsman/director.yml \
  --vars-file $foundation_config_path/vars/director.yml"
bosh int --var-errs --var-errs-unused $foundation_config_path/opsman/director.yml \
  --vars-file $foundation_config_path/vars/director.yml
