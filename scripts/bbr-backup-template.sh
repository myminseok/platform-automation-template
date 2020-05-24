#!/usr/bin/env bash

set -eux

current_date="$( date +"%Y-%m-%d-%H-%M-%S" )"

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "WORK_DIR/env.yml test" $WORK_DIR/env.yml

cat $WORK_DIR/env.yml

BOSH_ENVIRONMENT="1.1.1.1"
export BOSH_BBR_ACCOUNT=bbr
export BACKUP_FILE="$WORK_DIR/${BOSH_ENVIRONMENT}_director-backup_${current_date}.tar"

pushd $WORK_DIR/backup-artifact

    echo "test" $WORK_DIR/backup-artifact/bbr-artifcat-test
    
	tar -cvf "$BACKUP_FILE" --remove-files -- */*

popd