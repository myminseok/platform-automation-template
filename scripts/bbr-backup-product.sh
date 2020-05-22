#!/bin/bash

if [ -z $1 ] ; then
    echo "!!! please provide parameters"
    echo "${BASH_SOURCE[0]} [PRODUCT_NAME]"
    echo "${BASH_SOURCE[0]} cf"
    exit
fi  
PRODUCT_NAME=$1


set -eu

export timestamp="$(date '+%Y%m%d.%-H%M.%S+%Z')"


om --env env.yml bosh-env > bosh-env.sh
source ./bosh-env.sh

# Get CF deployment guid
om --env env.yml  curl -p /api/v0/deployed/products > deployed_products.json
DEPLOYMENT_NAME=$(jq -r '.[] | select(.type == "'${PRODUCT_NAME}'") | .guid' "deployed_products.json")
export DEPLOYMENT_NAME
echo $DEPLOYMENT_NAME


bbr deployment \
    --target "${BOSH_ENVIRONMENT}" \
    --username $BOSH_CLIENT \
    --deployment "$DEPLOYMENT_NAME" \
    --ca-cert "${BOSH_CA_CERT}"  \
    pre-backup-check


bbr deployment \
    --target "${BOSH_ENVIRONMENT}" \
    --username $BOSH_CLIENT \
    --deployment "$DEPLOYMENT_NAME" \
    --ca-cert "${BOSH_CA_CERT}"  \
    backup


BBR_BACKUP_FILE="cf"
OUTPUT_FILE_NAME="$(echo "$BBR_BACKUP_FILE" | envsubst '$timestamp')"

ls -al ./"$DEPLOYMENT_NAME"
tar zcf ./generated-backup/$OUTPUT_FILE_NAME  -C ./"$DEPLOYMENT_NAME" .

rm -rf ./"$DEPLOYMENT_NAME"

### cf-c8399c1d00f7742d47a1_20190505T123820Z$ ll
#total 17G
#10K backup_restore-0-azure-blobstore-backup-restorer.tar
#20K backup_restore-0-backup-restore-notifications.tar
#20K backup_restore-0-backup-restore-pcf-autoscaling.tar
#1.2M backup_restore-0-bbr-cfnetworkingdb.tar
#176M backup_restore-0-bbr-cloudcontrollerdb.tar
#10K backup_restore-0-bbr-credhubdb.tar
#10K backup_restore-0-bbr-routingdb.tar
#120K backup_restore-0-bbr-uaadb.tar
#423M backup_restore-0-bbr-usage-servicedb.tar
#10K backup_restore-0-nfsbroker-bbr.tar
#10K backup_restore-0-s3-unversioned-blobstore-backup-restorer.tar
#10K backup_restore-0-s3-versioned-blobstore-backup-restorer.tar
#33K metadata
#10K nfs_server-0-blobstore-backup.tar
#16G nfs_server-0-blobstore.tar

