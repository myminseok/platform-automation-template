Platform automation pipeline using Platform automation Toolkit

## documentation
- for download_depencencies to s3, see https://github.com/myminseok/pivotal-docs/blob/master/platform-automation/download_dependencies.md
- for install opsman, see https://github.com/myminseok/pivotal-docs/blob/master/platform-automation/install_opsman.md



### configuration Description

| Folder/File | Purposes | Samples  |
| --- | --- | --- |
| `<FOUNDATION-CODE>`  | As the root folder for a dedicated foundation | This can be something like `dev`, `qa`, `sit`, `prod` etc. which is up to the team's convention to name the foundations. |
| versions.yml | contains all products versions setting to configure and install | https://github.com/brightzheng100/semver-config-concourse-resource |\
| opsman | all config for opsman VM, director VM.  | The default `auth.yml` is for basic authentication. Please refer to sample of `auth-ldap.yml` and `auth-saml.yml` for other mechanisms. env.yml contains properties for targeting and logging into the Ops Manager API. Currently there is only one `env.yml` to configure the properties so that the `platform-automation` tasks can use `om --env the-path-to/env.yml <COMMAND> ...` to interact with OpsMan APIs |
| products | A folder to contain templatized product configs  | A couple of samples have been provided but please remove all of them to start with . version.yml is source of versions to be installed |
| state | A folder to contain the meta information named `state.yml` to manage the Ops Manager VM. This content of this file will be managed by pipelines during operations.  | A sample has been provided for GCP. Please change the IaaS code to meet your context |
| vars | A folder to contain vars for templatized product configs in folder of `/products` | A couple of samples have been provided but please remove all of them to start with |
| generated-config | A folder to contain automatically generated product config files during operations, it should start with no files  | A naming convention of `<PRODUCT-NAME>-<PRODUCT-VERSION>.yml` will be applied to all the files within this folder, e.g. `cf-2.2.11.yml`, `director-2.4.1.yml` |
| pipeline-vars | params files for `fly set-pipeline `, other files to params to concourse credhub. |  |\

## How to generate a product config 

#### install cli
- bosh (https://bosh.io/docs/cli-v2/)
- om (https://github.com/pivotal-cf/om/releases)

#### create foundation config folder
- `<FOUNDATION-CODE>`is any name you would like to manage.
- for example, `my-dev` in this example.
```
git clone git@github.com:myminseok/platform-automation-template.git
cd platform-automation-template/foundations
mkdir my-dev
cd my-dev
```
#### set product version info
- set products version info to install
- for example,  platform-automation-template/foundations/my-dev/versions.yml
```
products:
  tas:
    product-version: "2.9.4"
    pivnet-product-slug: elastic-runtime
    pivnet-file-glob: "cf*.pivotal"
    stemcell-iaas: vsphere
    s3-endpoint: ((s3_endpoint))
    s3-region-name: ((s3_region))
    s3-bucket: ((s3_bucket))
    s3-disable-ssl: "true"
    s3-access-key-id: ((s3_access_key_id))
    s3-secret-access-key: ((s3_secret_access_key))
    pivnet-api-token: ((pivnet_token))
```
> products.tas: `PRODUCT_ALIAS` you named in your pipeline 

#### generate product config from product template
- export PIVNET_TOKEN: from network.pivotal.io> edit profiles
- use om cli, bosh cli
```
$ generate-product-config.sh <FOUNDATION-CODE> <PRODUCT_ALIAS>
```
> FOUNDATION-CODE
> PRODUCT_ALIAS: product name from versions.yml

```
$ cd platform-automation-template/generate-config-scripts

$ export PIVNET_TOKEN=abcd

$ ./generate-product-config.sh my-dev tas
FOUNDATION: my-dev
PRODUCT: tas
version: 2.9.4
glob: cf*.pivotal
slug: elastic-runtime
...
Generating configuration for product tas

Checking pre-defined opsfile options to control config template ...
-> ''
Generating product template ... generated-products/tas.yml
 -> platform-automation-template/generate-config-scripts/../foundations/my-dev/generated-products/tas.yml

Generating product default-vars ... generated-vars/tas.yml
 -> platform-automation-template/generate-config-scripts/../foundations/my-dev/generated-vars/tas.yml
Complete
```



#### validate product config from product template
- use om cli, bosh cli
```
$ validate-product-config.sh <FOUNDATION-CODE> <PRODUCT_ALIAS>
```
> FOUNDATION-CODE: 
> PRODUCT_ALIAS: product name from versions.yml

```
$ cd platform-automation-template/generate-config-scripts
$ ./validate-product-config.sh my-dev tas
Validating configuration for product tas
bosh int --var-errs generate-config-scripts/../foundations/my-dev/generated-products/tas.yml  
--vars-file ../foundations/my-dev/vars/tas.yml 
--vars-file ../foundations/my-dev/generated-vars/tas.yml 

- Expected to find variables:
    - cloud_controller_apps_domain
    - cloud_controller_system_domain
    - credhub_internal_provider_keys_0_key
    - credhub_internal_provider_keys_0_name
    - haproxy_forward_tls_enable_backend_ca
    - mysql_monitor_recipient_email
    - network_name
    - networking_poe_ssl_certs_0_certificate
    - networking_poe_ssl_certs_0_name
    - networking_poe_ssl_certs_0_privatekey
    - security_acknowledgement
    - singleton_availability_zone
    - uaa_service_provider_key_credentials_certificate
    - uaa_service_provider_key_credentials_privatekey

```
> above list should be set in var file or concourse credhub.

#### adjust product tile options 
- full list of options for the product tile config comes from download files by ` om config-template` command 
- product templates are download when running `genrate-product-config.sh` command.
```
$ cd platform-automation-template/generate-config-scripts/downloaded-tile-config-templates/<PRODUCT_ALIAS>/
$ cd ./tas/2.9.4

├── default-vars.yml
├── errand-vars.yml
├── features
│   ├── app_log_rate_limiting-enable.yml
│   ├── cc_api_rate_limit-enable.yml
│   ├── container_networking_interface_plugin-external.yml
│   ├── credhub_database-external.yml
│   ├── haproxy_forward_tls-disable.yml

```
- create a file under foundations/my-dev/opsfiles/`<FOUNDATION-CODE>`-operations
- for example, platform-automation-template/foundations/my-dev/opsfiles/tas-operations
```
features/haproxy_forward_tls-disable.yml
optional/add-credhub_hsm_provider_client_certificate.yml
features/tcp_routing-enable.yml
features/container_networking_interface_plugin-external.yml
optional/add-routing_custom_ca_certificates.yml
```

#### re-run generating  product config and validating the config.
```
$ cd platform-automation-template/generate-config-scripts
$ ./generate-product-config.sh my-dev tas
$ ./validate-product-config.sh my-dev tas
```

#### check the generated product config template.
- generated product config file: foundations/my-dev/generated-products/`<FOUNDATION-CODE>`.yml
- generated product config params file: foundations/my-dev/generated-vars/`<FOUNDATION-CODE>`.yml
- to use the config in the pipeline, copy generated-products/`<FOUNDATION-CODE>`.yml to products/`<FOUNDATION-CODE>`.yml
```
$ cp foundations/my-dev/generated-products/tas.yml foundations/my-dev/products/tas.yml
```

#### set product params in foundation config var file.
- foundations/my-dev/vars/`<FOUNDATION-CODE>`.yml
- for example, platform-automation-template/foundations/my-dev/vars/tas.yml
```
cloud_controller_apps_domain: apps.awstest.pcfdemo.net
cloud_controller_system_domain: sys.awstest.pcfdemo.net
mysql_monitor_recipient_email: test@cloud.com
```

#### set product SECRETS params to concourse credhub.
- https://docs.pivotal.io/platform-automation/v4.4/concepts/secrets-handling.html