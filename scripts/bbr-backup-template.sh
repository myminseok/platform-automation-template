#!/usr/bin/env bash

set -eux

current_date="$( date +"%Y-%m-%d-%H-%M-%S" )"

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "WORK_DIR/env.yml test" $WORK_DIR/env.yml

cat $WORK_DIR/env.yml

BOSH_ENVIRONMENT="1.1.1.1"
export BOSH_BBR_ACCOUNT=bbr
export BACKUP_FILE="${BOSH_ENVIRONMENT}_director-backup_${current_date}.tgz"

TMP_DIR="$WORK_DIR/${BASH_SOURCE[0]}_${current_date}"
mkdir -p $TMP_DIR
pushd $TMP_DIR

    echo "test" > $TMP_DIR/bbr-artifcat-test
    
popd

tar -zcvf $WORK_DIR/"$BACKUP_FILE" -C $TMP_DIR . --remove-files