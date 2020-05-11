#!/usr/bin/env bash

cat /var/version && echo ""
set -euo pipefail


wget https://github.com/cloudfoundry-incubator/credhub-cli/releases/download/2.7.0/credhub-linux-2.7.0.tgz
tar xf credhub-linux-2.7.0.tgz
mv credhub /usr/local/bin/credhub



if [ ! -f "./$TERRAFORM_STATE_FILE_PATH" ]; then
  echo "Required terraform state file does not exist in './$TERRAFORM_STATE_FILE_PATH'"
  exit 1
fi

# NOTE: The credhub cli does not ignore empty/null environment variables.
# https://github.com/cloudfoundry-incubator/credhub-cli/issues/68
if [ -z "$CREDHUB_CA_CERT" ]; then
  unset CREDHUB_CA_CERT
fi

credhub --version

if [ -z "$PREFIX" ]; then
  echo "Please specify a PREFIX. It is required."
  exit 1
fi

if [ "$SKIP_TLS_VALIDATION" == "true" ]; then
  export SKIP_TLS_VALIDATION="--skip-tls-validation"
fi

credhub login -s $CREDHUB_SERVER --client-name=$CREDHUB_CLIENT --client-secret=$CREDHUB_SECRET $SKIP_TLS_VALIDATION


function set_value(){
    local KEY=$1 
    value=`terraform output -state ${TERRAFORM_STATE_FILE_PATH} ${KEY}`
    credhub set -t value -n ${PREFIX}/${FOUNDATION_PREFIX}${KEY} -v "$value"
}

function set_password(){
    local KEY=$1 
    value=`terraform output -state ${TERRAFORM_STATE_FILE_PATH} ${KEY}`
    credhub set -t password -n ${PREFIX}/${FOUNDATION_PREFIX}${KEY} -w "$value"
}



function set_first_value_from_array(){
    local KEY=$1 
    value=`terraform output -state ${TERRAFORM_STATE_FILE_PATH} ${KEY} | awk -F',' '{print $1}' | head -n 1`
    credhub set -t value -n ${PREFIX}/${FOUNDATION_PREFIX}${KEY} -v "$value"
}


function set_ssh_private_key(){
    local KEY=$1 
    terraform output -state ${TERRAFORM_STATE_FILE_PATH} ${KEY}  > ./tmp_set_ssh_private_key
    credhub set -t rsa -n ${PREFIX}/${FOUNDATION_PREFIX}${KEY} -p ./tmp_set_ssh_private_key
}




## for opsman.yml , director.yml
set_first_value_from_array "public_subnet_ids" ##  module.infra.public_subnet_ids, 0
set_value "ops_manager_security_group_id"
set_value "ops_manager_ssh_public_key_name"
set_value "ops_manager_iam_instance_profile_name"
set_value "ops_manager_public_ip"
set_ssh_private_key "ops_manager_ssh_private_key"

##set_value "ops_manager_iam_user_access_key"
##set_password "ops_manager_iam_user_secret_key"
#set_value "rds_address"
#set_value "rds_username"
#set_password "rds_password"


if [ -f "${SHELL_FILE_FOR_KEY_LIST}" ]; then
  echo "executing ${SHELL_FILE_FOR_KEY_LIST} "
  source ${SHELL_FILE_FOR_KEY_LIST}
fi

