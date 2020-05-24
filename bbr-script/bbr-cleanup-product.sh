#!/bin/bash
set -eu

if [ -z $1 ] ; then
    echo "!!! please provide parameters"
    echo "${BASH_SOURCE[0]} [PRODUCT_NAME]"
    echo "${BASH_SOURCE[0]} cf"
    exit
fi  
PRODUCT_NAME=$1

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

om --env $WORK_DIR/env.yml bosh-env > $WORK_DIR/bosh-env.sh
source $WORK_DIR/bosh-env.sh

# Get CF deployment guid
om --env $WORK_DIR/env.yml  curl -p /api/v0/deployed/products > $WORK_DIR/deployed_products.json
DEPLOYMENT_NAME=$(jq -r '.[] | select(.type == "'${PRODUCT_NAME}'") | .guid' "$WORK_DIR/deployed_products.json")
export DEPLOYMENT_NAME
echo $DEPLOYMENT_NAME

bbr deployment \
    --target "${BOSH_ENVIRONMENT}" \
    --username $BOSH_CLIENT \
    --password $BOSH_CLIENT_SECRET \
    --deployment "$DEPLOYMENT_NAME" \
    --ca-cert "${BOSH_CA_CERT}" \
    backup-cleanup


