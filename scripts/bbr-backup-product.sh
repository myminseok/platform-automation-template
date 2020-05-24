#!/bin/bash
set -eu


if [ -z $1 ] ; then
    echo "!!! please provide parameters"
    echo "${BASH_SOURCE[0]} [PRODUCT_NAME]"
    echo "${BASH_SOURCE[0]} cf"
    exit
fi  
PRODUCT_NAME=$1


export timestamp="$(date '+%Y%m%d.%-H%M.%S+%Z')"

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

om --env $WORK_DIR/env.yml bosh-env > $WORK_DIR/bosh-env.sh
source $WORK_DIR/bosh-env.sh

# Get CF deployment guid
om --env $WORK_DIR/env.yml  curl -p /api/v0/deployed/products > $WORK_DIR/deployed_products.json
DEPLOYMENT_NAME=$(jq -r '.[] | select(.type == "'${PRODUCT_NAME}'") | .guid' "$WORK_DIR/deployed_products.json")
export DEPLOYMENT_NAME
echo $DEPLOYMENT_NAME


export BACKUP_FILE="${BOSH_ENVIRONMENT}-${PRODUCT_NAME}-backup_${current_date}.tar"
pushd $WORK_DIR

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

    tar -cvf "$BACKUP_FILE" --remove-files -- */*
popd

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

