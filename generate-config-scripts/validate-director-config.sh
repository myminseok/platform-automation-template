#!/bin/bash -e
## original code from https://github.com/tonyelmore/telmore-platform-automation

if [ ! $# -eq 1 ] ; then
    echo "${BASH_SOURCE[0]} FOUNDATION"
    exit
fi  

FOUNDATION=$1

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
## TODO will not use IAAS at the moment
##foundation_config_path="$WORK_DIR/../${IAAS}/${FOUNDATION}"
foundation_config_path="$WORK_DIR/../foundations/${FOUNDATION}"

echo "Validating configuration for director"
echo "bosh int --var-errs --var-errs-unused \"
echo "  ../foundations/${FOUNDATION}/opsman/director.yml \"
echo "  --vars-file ../foundations/${FOUNDATION}/vars/director.yml"

touch $foundation_config_path/vars/director.yml
bosh int --var-errs --var-errs-unused $foundation_config_path/opsman/director.yml \
  --vars-file $foundation_config_path/vars/director.yml
