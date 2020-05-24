#!/usr/bin/env bash

cat /var/version && echo ""
set -euo pipefail


wget https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.7.0/credhub-linux-2.7.0.tgz
tar xf credhub-linux-2.7.0.tgz
mv credhub /usr/local/bin/credhub


# NOTE: The credhub cli does not ignore empty/null environment variables.
# https://github.com/cloudfoundry-incubator/credhub-cli/issues/68
if [ -z "$CREDHUB_CA_CERT" ]; then
  unset CREDHUB_CA_CERT
fi

#credhub --version

if [ -z "$PREFIX" ]; then
  echo "Please specify a PREFIX. It is required."
  exit 1
fi

if [ "$SKIP_TLS_VALIDATION" == "true" ]; then
  export SKIP_TLS_VALIDATION="--skip-tls-validation"
fi

credhub login -s $CREDHUB_SERVER --client-name=$CREDHUB_CLIENT --client-secret=$CREDHUB_SECRET $SKIP_TLS_VALIDATION

credhub find


if [ ! -f "./$TERRAFORM_STATE_FILE_PATH" ]; then
  echo "Required terraform state file does not exist in './$TERRAFORM_STATE_FILE_PATH'"
  exit 1
fi


echo "====================================="
if [ -f "${SHELL_FILE}" ]; then
  echo "Executing ${SHELL_FILE} "
  chmod +x ${SHELL_FILE}
  ${SHELL_FILE} $PIPELINE_NAME $TERRAFORM_STATE_FILE_PATH
else
  echo "No extra file shell file to execute from SHELL_FILE: $SHELL_FILE "
fi

