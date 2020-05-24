#!/usr/bin/env bash

set -eux


WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

om --env $WORK_DIR/env.yml bosh-env > $WORK_DIR/bosh-env.sh
source $WORK_DIR/bosh-env.sh


export BBR_SSH_KEY_PATH=$WORK_DIR/bbr_ssh_credentials
# Get bbr ssh credentials
om --env $WORK_DIR/env.yml curl -p /api/v0/deployed/director/credentials/bbr_ssh_credentials > $WORK_DIR/bbr_ssh_credentials.json

## parse deployment
cat $BBR_SSH_KEY_PATH
jq -r '.[] | .value.private_key_pem' "bbr_ssh_credentials.json" > $BBR_SSH_KEY_PATH


export BOSH_BBR_ACCOUNT=bbr
export BACKUP_FILE="$WORK_DIR/${BOSH_ENVIRONMENT}_director-backup_${current_date}.tar"
pushd $WORK_DIR
    
    bbr director --host "${BOSH_ENVIRONMENT}" \
	  --username $BOSH_BBR_ACCOUNT \
	  --private-key-path $BBR_SSH_KEY_PATH \
	  backup-cleanup

    bbr director --host "${BOSH_ENVIRONMENT}" \
	  --username $BOSH_BBR_ACCOUNT \
	  --private-key-path $BBR_SSH_KEY_PATH \
	  pre-backup-check

	bbr director --host "${BOSH_ENVIRONMENT}" \
	  --username $BOSH_BBR_ACCOUNT \
	  --private-key-path $BBR_SSH_KEY_PATH \
	  backup

	tar -cvf "$BACKUP_FILE" --remove-files -- */*

popd