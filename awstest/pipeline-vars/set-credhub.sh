
credhub set -t value -n /concourse/main/aws_access_key_id -v ""
credhub set -t value -n /concourse/main/aws_secret_access_key -v ""

# credhub set -t user -n /concourse/main/vcenter_user -z admin@vcenter.local -w "PASSWORD"
# credhub set -t user -n /concourse/main/vcenter_user -z admin@vcenter.local -w "PASSWORD"

credhub set -t value -n /concourse/main/pivnet_token -v ""
credhub set -t value -n /concourse/main/git_user_email -v admin@user.io
credhub set -t value -n /concourse/main/git_user_username -v admin

## register ssh key for git. ex) ~/.ssh/id_rsa
credhub set -t rsa  -n /concourse/main/git_private_key  -p ~/.ssh/id_rsa
 
## cd concourse-bosh-deployment/cluster
## bosh int ./concourse-creds.yml --path /atc_tls/certificate > atc_tls.cert
## bosh int ./credhub-vars-store.yml --path=/credhub-ca/ca > credhub-ca.ca
# credhub set -t certificate -n /concourse/main/credhub_ca_cert -c ./credhub-ca.ca

## grep concourse_to_credhub ./concourse-creds.yml
credhub set -t user -n /concourse/main/credhub_client -z concourse_client -w "secret"

# credhub set -t ssh -n /concourse/main/opsman_ssh_key -u ~/.ssh/id_rsa.pub -p ~/.ssh/id_rsa
credhub set -t user  -n /concourse/main/opsman_admin -z admin -w ""
credhub set -t value -n /concourse/main/decryption-passphrase -v ""
credhub set -t value -n /concourse/main/opsman_target -v "https://"



## terraform output  for credhub interpolate, naming rule is "/concourse/main/FOUNDATION_key...""
credhub set -t value -n /concourse/main/awstest_ops_manager_public_ip -v ""
## module.infra.public_subnet_ids, 0
credhub set -t value -n /concourse/main/awstest_opsman_vpc_subnet_id -v "subnet-" 
credhub set -t value -n /concourse/main/awstest_opsman_security_group_ids -v "sg-"
credhub set -t value -n /concourse/main/awstest_opsman_key_pair_name -v ""
credhub set -t value -n /concourse/main/awstest_opsman_iam_instance_profile_name -v ""


credhub set -t value -n /concourse/main/awstest_ops_manager_iam_user_access_key -v ""
credhub set -t value -n /concourse/main/awstest_ops_manager_iam_user_secret_key -v ""
credhub set -t value -n /concourse/main/awstest_rds_address -v ""
credhub set -t value -n /concourse/main/awstest_rds_password -v ""
credhub set -t value -n /concourse/main/awstest_rds_username -v ""




