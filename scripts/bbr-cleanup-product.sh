#!/bin/bash

if [ -z $1 ] ; then
    echo "!!! please provide parameters"
    echo "${BASH_SOURCE[0]} [PRODUCT_NAME]"
    echo "${BASH_SOURCE[0]} cf"
    exit
fi  
PRODUCT_NAME=$1

set -eu

om --env env.yml bosh-env > bosh-env.sh
source ./bosh-env.sh

# Get CF deployment guid
om --env env.yml  curl -p /api/v0/deployed/products > deployed_products.json
DEPLOYMENT_NAME=$(jq -r '.[] | select(.type == "'${PRODUCT_NAME}'") | .guid' "deployed_products.json")
export DEPLOYMENT_NAME
echo $DEPLOYMENT_NAME
echo $DEPLOYMENT_NAME


bbr deployment \
    --target "${BOSH_ENVIRONMENT}" \
    --username $BOSH_CLIENT \
    --password $BOSH_CLIENT_SECRET \
    --deployment "$DEPLOYMENT_NAME" \
    --ca-cert "${BOSH_CA_CERT}" \
    backup-cleanup


