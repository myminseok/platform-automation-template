#!/usr/bin/env bash

set -eux

export timestamp="$(date '+%Y%m%d.%-H%M.%S+%Z')"


#cat deployed_products.json
## install jq
apt-get install jq -y


mkdir ./backup-tmp
echo $timestamp > ./backup-tmp/timestamp

om --env ./config/$ENV_FILE bosh-env > bosh-env.sh
source ./bosh-env.sh

# Get bbr ssh credentials
om --env ./config/$ENV_FILE curl -p /api/v0/deployed/director/credentials/bbr_ssh_credentials > bbr_ssh_credentials.json


export BOSH_BBR_ACCOUNT=bbr

## parse deployment
jq -r '.[] | .value.private_key_pem' "bbr_ssh_credentials.json" > bbr_ssh_credentials


mv ./bbr-release/*linux* ./bbr
chmod +x ./bbr


./bbr director --host "${BOSH_ENVIRONMENT}" \
    --username $BOSH_BBR_ACCOUNT \
    --private-key-path ./bbr_ssh_credentials \
    backup-cleanup

./bbr director --host "${BOSH_ENVIRONMENT}" \
    --username $BOSH_BBR_ACCOUNT \
    --private-key-path ./bbr_ssh_credentials \
    pre-backup-check

./bbr director --host "${BOSH_ENVIRONMENT}" \
    --username $BOSH_BBR_ACCOUNT \
    --private-key-path ./bbr_ssh_credentials \
    backup --artifact-path ./backup-tmp

./bbr director --host "${BOSH_ENVIRONMENT}" \
    --username $BOSH_BBR_ACCOUNT \
    --private-key-path ./bbr_ssh_credentials \
    backup-cleanup


OUTPUT_FILE_NAME="$(echo "$BBR_BACKUP_FILE" | envsubst '$timestamp')"

ls -al ./backup-tmp
tar zcf ./generated-backup/$OUTPUT_FILE_NAME -C ./backup-tmp .
rm -rf ./backup-tmp
