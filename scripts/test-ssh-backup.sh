#!/usr/bin/env bash

set -eux

export timestamp="$(date '+%Y%m%d.%-H%M.%S+%Z')"

WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "WORK_DIR/env.yml test" $WORK_DIR/env.yml

cat $WORK_DIR/env.yml

BOSH_ENVIRONMENT="1.1.1.1"
export BOSH_BBR_ACCOUNT=bbr
export BACKUP_FILE="${BOSH_ENVIRONMENT}_director-backup_${timestamp}.tgz"

SCRIPT_NAME=$(basename ${BASH_SOURCE[0]})
TMP_DIR="$WORK_DIR/${SCRIPT_NAME}_${timestamp}"
echo $TMP_DIR
mkdir -p $TMP_DIR
pushd $TMP_DIR

    echo "test" > $TMP_DIR/bbr-artifcat-test
    
popd

tar -zcvf $WORK_DIR/"$BACKUP_FILE" -C $TMP_DIR . --remove-files