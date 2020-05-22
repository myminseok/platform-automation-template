## see platform-automation-pipelines/tasks/prepare-credhub-secrets-from-terraform-state.yml

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