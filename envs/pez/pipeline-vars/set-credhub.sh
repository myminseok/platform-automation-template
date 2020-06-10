#!/bin/bash

if [ -z $1 ] ; then
    echo "please provide parameters"
	echo "${BASH_SOURCE[0]} PIPELINE_NAME"
	exit
fi	

PIPELINE_NAME=$1	
PREFIX='/concourse/main'


credhub set -t value -n /concourse/main/s3_access_key_id -v ''
credhub delete -n /concourse/main/s3_secret_access_key
credhub set -t password -n /concourse/main/s3_secret_access_key -w ''
## credhub set -t user -n /concourse/main/vcenter_user -z admin@vcenter.local -w "PASSWORD"
credhub set -t value -n /concourse/main/iaas-configurations_0_vcenter_username -v ''
credhub set -t password -n /concourse/main/iaas-configurations_0_vcenter_password -w ''


credhub delete -n /concourse/main/pivnet_token
credhub set -t password -n /concourse/main/pivnet_token -w ''
credhub set -t value -n /concourse/main/git_user_email -v admin@user.io
credhub set -t value -n /concourse/main/git_user_username -v ''
credhub set -t user -n /concourse/main/smtp_user -z user -w 'secret'

## register ssh key for git. ex) ~/.ssh/id_rsa
credhub set -t rsa  -n /concourse/main/git_private_key  -p ~/.ssh/id_rsa
 

## cd concourse-bosh-deployment/cluster
## bosh int ./concourse-creds.yml --path /atc_tls/certificate > atc_tls.cert
## bosh int ./credhub-vars-store.yml --path=/credhub-ca/ca > credhub-ca.ca
# credhub set -t certificate -n /concourse/main/credhub_ca_cert -c ./credhub-ca.ca
## grep concourse_to_credhub ./concourse-creds.yml
credhub set -t user -n /concourse/main/credhub_client -z concourse_client -w "$(bosh int ./credhub-vars-store.yml --path=/concourse_credhub_client_secret)"

credhub set -t user  -n ${PREFIX}/${PIPELINE_NAME}/opsman_admin -z admin -w 'PASSWORD'
credhub delete -n ${PREFIX}/${PIPELINE_NAME}/decryption-passphrase
credhub set -t password -n ${PREFIX}/${PIPELINE_NAME}/decryption-passphrase -w 'PASSWORD'
credhub set -t value -n ${PREFIX}/${PIPELINE_NAME}/opsman_target -v "https://opsman.pcfdemo.net"
# for opsman.yml on vsphere
credhub set -t rsa  -n ${PREFIX}/${PIPELINE_NAME}/opsman_ssh_key -u ~/.ssh/id_rsa.pub -p ~/.ssh/id_rsa

##*.pcfdemo.net,*.sys.pcfdemo.net,*.apps.pcfdemo.net,*.uaa.sys.pcfdemo.net,*.login.sys.pcfdemo.net
##credhub set -t certificate -n ${PREFIX}/${PIPELINE_NAME}/tas_ssl_domain -c ./tas_ssl_domain.crt -p ./tas_ssl_domain.key

credhub set -t value -n ${PREFIX}/${PIPELINE_NAME}/domain_hosted_zone_id -v ''
credhub set -t value -n ${PREFIX}/${PIPELINE_NAME}/domain_letsencrypt_email -v ''

credhub set -t user -n /concourse/main/smtp_user -z user -w 'secret'

## bosh credhub : credhub get -n /services/tls_ca -k ca
## TAS tile> networking> domain certifiate
#credhub set -t certificate -n ${PREFIX}/${PIPELINE_NAME}/director_trusted_certificates -c ./director_trusted_certificates

