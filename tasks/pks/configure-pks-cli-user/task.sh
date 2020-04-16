#!/bin/bash
## reference: https://github.com/pivotalservices/concourse-pipeline-samples/tree/master/tasks/pcf/pks/configure-pks-cli-user

set -eu

#apt-get install jq -y

wget https://github.com/pivotal-cf/om/releases/download/1.1.0/om-linux -O om
chmod +x om

./om --env ./env/$ENV_FILE bosh-env > bosh-env.sh
source ./bosh-env.sh


PKS_API_DOMAIN=$(grep 'pks_api_domain' ./env/${PKS_ENV_FILE} | awk -F'[ :]' '{gsub("[\"]", "", $3);print $3}')
PKS_CLI_USERNAME=$(grep 'pks_cli_username' ./env/${PKS_ENV_FILE} | awk -F'[ :]' '{gsub("[\"]", "", $3);print $3}')
PKS_CLI_USEREMAIL=$(grep 'pks_cli_useremail' ./env/${PKS_ENV_FILE} | awk -F'[ :]' '{gsub("[\"]", "", $3);print $3}')
PKS_CLI_PASSWORD=$(grep 'pks_cli_password' ./env/${PKS_ENV_FILE} | awk -F'[ :]' '{gsub("[\"]", "", $3);print $3}')


OPSMAN_DOMAIN_OR_IP_ADDRESS=`grep 'target' ./env/${ENV_FILE} | awk -F'[ :]' '{gsub("[\"]", "", $3);print $3}'`
echo "Retrieving PKS tile properties from Ops Manager [https://$OPSMAN_DOMAIN_OR_IP_ADDRESS]..."
# get PKS UAA admin credentails from OpsMgr
PRODUCTS=$(./om --env ./env/$ENV_FILE curl -p /api/v0/deployed/products)
PKS_GUID=$(echo "$PRODUCTS" | jq -r '.[] | .guid' | grep pivotal-container-service)
PKS_VERSION=$(echo "$PRODUCTS" | jq --arg PKS_GUID "$PKS_GUID" -r '.[] | select(.guid==$PKS_GUID) | .product_version')


PKS_UAA_ADMIN_SECRET_FIELD=".properties.pks_uaa_management_admin_client"  # for 1.1+
UAA_ADMIN_SECRET=$(./om --env ./env/$ENV_FILE curl -p /api/v0/deployed/products/$PKS_GUID/credentials/$PKS_UAA_ADMIN_SECRET_FIELD | jq -rc '.credential.value.secret')

echo "Connecting to PKS UAA server [<$PKS_API_DOMAIN>]..."
# login to PKS UAA
uaac target https://$PKS_API_DOMAIN:8443 --skip-ssl-validation
uaac token client get admin --secret $UAA_ADMIN_SECRET



echo "Creating PKS CLI administrator user per PK tile documentation https://docs.pivotal.io/runtimes/pks/1-0/manage-users.html#uaa-scopes"
# create pks admin user

uaac user delete "$PKS_CLI_USERNAME" 

uaac user add "$PKS_CLI_USERNAME" --emails "$PKS_CLI_USEREMAIL" -p "$PKS_CLI_PASSWORD"
uaac member add pks.clusters.admin "$PKS_CLI_USERNAME"
uaac member add pks.clusters.manage "$PKS_CLI_USERNAME"

echo "PKS CLI administrator user [$PKS_CLI_USERNAME] successfully created."

echo "Next, download the PKS CLI from Pivotal Network and login to the PKS API to create a new K8s cluster [https://docs.pivotal.io/runtimes/pks/1-0/create-cluster.html]"
echo "Example: "
echo "   pks login -a $PKS_API_DOMAIN -u $PKS_CLI_USERNAME -p <pks-cli-password-provided>"
