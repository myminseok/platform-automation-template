#!/usr/bin/env bash

set -eux

current_date="$( date +"%Y-%m-%d-%H-%M-%S" )"

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

om --env $WORK_DIR/env.yml bosh-env > $WORK_DIR/bosh-env.sh
source $WORK_DIR/bosh-env.sh

export BBR_SSH_KEY_PATH=$WORK_DIR/bbr_ssh_credentials
# Get bbr ssh credentials
om --env $WORK_DIR/env.yml curl -p /api/v0/deployed/director/credentials/bbr_ssh_credentials > $WORK_DIR/bbr_ssh_credentials.json

## parse deployment
cat $BBR_SSH_KEY_PATH
jq -r '.[] | .value.private_key_pem' "bbr_ssh_credentials.json" > $BBR_SSH_KEY_PATH


SCRIPT_NAME=$(basename ${BASH_SOURCE[0]})
TMP_DIR="$WORK_DIR/${SCRIPT_NAME}_${current_date}"
echo $TMP_DIR
mkdir -p $TMP_DIR
pushd $TMP_DIR

    export BOSH_BBR_ACCOUNT=bbr

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

popd
export BACKUP_FILE="${BOSH_ENVIRONMENT}_director-backup_${current_date}.tgz"
tar -zcvf $WORK_DIR/"$BACKUP_FILE" -C $TMP_DIRs . --remove-files


