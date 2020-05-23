#!/usr/bin/env bash

set -eux


om --env env.yml bosh-env > bosh-env.sh
source ./bosh-env.sh
export BOSH_BBR_ACCOUNT=bbr

# Get bbr ssh credentials
om --env env.yml curl -p /api/v0/deployed/director/credentials/bbr_ssh_credentials > bbr_ssh_credentials.json


## parse deployment
cat bbr_ssh_credentials.json
jq -r '.[] | .value.private_key_pem' "bbr_ssh_credentials.json" > bbr_ssh_credentials


export BOSH_BBR_ACCOUNT=bbr
export BBR_SSH_KEY_PATH="bbr_ssh_credentials"



bbr director --host "${BOSH_ENVIRONMENT}" --username $BOSH_BBR_ACCOUNT --private-key-path $BBR_SSH_KEY_PATH \
    backup-cleanup

bbr director --host "${BOSH_ENVIRONMENT}" --username $BOSH_BBR_ACCOUNT --private-key-path $BBR_SSH_KEY_PATH \
    pre-backup-check

export BBR_BACKUP_TMP_DIR="./bbr-backup-tmp"
mkdir -p $BBR_BACKUP_TMP_DIR
echo $timestamp > $BBR_BACKUP_TMP_DIR/timestamp

bbr director --host "${BOSH_ENVIRONMENT}" --username $BOSH_BBR_ACCOUNT --private-key-path $BBR_SSH_KEY_PATH \
    backup --artifact-path ./



OUTPUT_FILE_NAME="$(echo "$BBR_BACKUP_FILE" | envsubst '$timestamp')"

ls -al $BBR_BACKUP_TMP_DIR
tar cf ./generated-backup/$OUTPUT_FILE_NAME -C $BBR_BACKUP_TMP_DIR .
rm -rf $BBR_BACKUP_TMP_DIRs
