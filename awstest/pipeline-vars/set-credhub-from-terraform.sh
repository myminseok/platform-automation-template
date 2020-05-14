#!/bin/bash



if [ -z $1 ] || [ -z $2 ] ; then
    echo "please provide parameters"
	echo "${BASH_SOURCE[0]} PIPELINE_NAME TERRAFORM_STATE_FILE_PATH"
	exit
fi	

PIPELINE_NAME=$1	
TERRAFORM_STATE_FILE_PATH=$2

PREFIX='/concourse/main'


if [ ! -f "$TERRAFORM_STATE_FILE_PATH" ]; then
  echo "Required terraform state file does not exist: $TERRAFORM_STATE_FILE_PATH'"
  exit 1
fi



function set_value(){
    local KEY=$1 
    value=`terraform output -state ${TERRAFORM_STATE_FILE_PATH} ${KEY}`
    credhub set -t value -n ${PREFIX}/${PIPELINE_NAME}/${KEY} -v "$value"
}

function set_password(){
    local KEY=$1 
    value=`terraform output -state ${TERRAFORM_STATE_FILE_PATH} ${KEY}`
    credhub set -t password -n ${PREFIX}/${PIPELINE_NAME}/${KEY} -w "$value"
}



function set_first_value_from_array(){
    local KEY=$1 
    value=`terraform output -state ${TERRAFORM_STATE_FILE_PATH} ${KEY} | awk -F',' '{print $1}' | head -n 1`
    credhub set -t value -n ${PREFIX}/${PIPELINE_NAME}/${KEY} -v "$value"
}


function set_ssh_private_key(){
    local KEY=$1 
    terraform output -state ${TERRAFORM_STATE_FILE_PATH} ${KEY}  > ./tmp_set_ssh_private_key
    credhub delete -n ${PREFIX}/${PIPELINE_NAME}${KEY} 
    credhub set -t rsa -n ${PREFIX}/${PIPELINE_NAME}/${KEY} -p ./tmp_set_ssh_private_key
}





## for opsman.yml , director.yml
set_first_value_from_array "public_subnet_ids" ##  module.infra.public_subnet_ids, 0
set_value "ops_manager_security_group_id"
set_value "ops_manager_ssh_public_key_name"
set_value "ops_manager_iam_instance_profile_name"
set_value "ops_manager_public_ip"
set_ssh_private_key "ops_manager_ssh_private_key"

set_value "ops_manager_iam_user_access_key"
set_password "ops_manager_iam_user_secret_key"
#set_value "rds_address"
#set_value "rds_username"
#set_password "rds_password"


