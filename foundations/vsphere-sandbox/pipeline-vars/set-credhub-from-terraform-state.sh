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
    local value=`terraform output -state ${TERRAFORM_STATE_FILE_PATH} ${KEY}`
    echo "$KEY: $value"
    credhub set -t value -n ${PREFIX}/${PIPELINE_NAME}/${KEY} -v "$value"
}

function set_password(){
    local KEY=$1 
    local value=`terraform output -state ${TERRAFORM_STATE_FILE_PATH} ${KEY}`
    echo "$KEY: $value"
    credhub set -t password -n ${PREFIX}/${PIPELINE_NAME}/${KEY} -w "$value"
}



function set_value_from_array(){
    local KEY=$1 
    local INDEX=$2
    local value=$(terraform output -json -state ${TERRAFORM_STATE_FILE_PATH} ${KEY} | jq -r '.value['$INDEX']')
    echo "${KEY}_${INDEX}: $value"
    credhub set -t value -n ${PREFIX}/${PIPELINE_NAME}/${KEY}_${INDEX} -v "$value"
}


function set_ssh_private_key(){
    local KEY=$1 
    terraform output -state ${TERRAFORM_STATE_FILE_PATH} ${KEY}  > /tmp/tmp_set_ssh_private_key
    echo "$KEY: $value"
    #credhub delete -n ${PREFIX}/${PIPELINE_NAME}${KEY} 
    credhub set -t rsa -n ${PREFIX}/${PIPELINE_NAME}/${KEY} -p /tmp/tmp_set_ssh_private_key
    rm -rf /tmp/tmp_set_ssh_private_key
}





## for opsman.yml , director.yml
set_value_from_array "public_subnet_ids" 0 ##  module.infra.public_subnet_ids, 0
set_value "ops_manager_security_group_id"
set_value "ops_manager_ssh_public_key_name"
set_value "ops_manager_iam_instance_profile_name"
set_value "ops_manager_public_ip"
set_ssh_private_key "ops_manager_ssh_private_key"
set_value "ops_manager_iam_user_access_key"
set_password "ops_manager_iam_user_secret_key"
set_value "vms_security_group_id"

set_value_from_array "infrastructure_subnet_ids" 0 
set_value_from_array "infrastructure_subnet_ids" 1
set_value_from_array "infrastructure_subnet_ids" 2

set_value_from_array "pas_subnet_ids" 0 
set_value_from_array "pas_subnet_ids" 1
set_value_from_array "pas_subnet_ids" 2

set_value_from_array "services_subnet_ids" 0
set_value_from_array "services_subnet_ids" 1
set_value_from_array "services_subnet_ids" 2


#set_value "rds_address"
#set_value "rds_username"
#set_password "rds_password"


