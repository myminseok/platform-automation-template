This Platform automation pipeline will provide following benefits.
- 1) simple to manage pipeline source code by managing small standard pipelines as template.
- 2) fully compatible foundation config structure to [platform automation guide](https://docs.pivotal.io/platform-automation/v5.0/). you can share the same pipeline code for multiple foundation.
- 3) you can merge all pipelines into single pipeline for the foundation, so that you can control pipeline's job concurrency using concourse [serial_group](https://concourse-ci.org/jobs.html#schema.job.serial_groups). you can remove or add products from the merged pipeplie in a simple way.


# Folder structure
- foundations/FOUNDATION/download-products: yml file for each product used to yml file for each product. 
- foundations/FOUNDATION/opsman: all files regards to opsman such as env.yml, opsman.yml, director.yml
- foundations/FOUNDATION/pipeline-vars: params.yml is used to `fly set-pipeline` directly. this is not used inside of pipeline task.
- foundations/FOUNDATION/products: yml file for each product config. it is the same yml format used for `om configure-product` 
- foundations/FOUNDATION/vars: optional yml file for each product config to provide paramters
- foundations/FOUNDATION/versions:  yml file for each product to download from s3 to install, upgrade, patch.
- foundations/FOUNDATION/trigger-backup, trigger-xxx: optional `semver` file used in pipelines.
- [pipelines-templates](pipelines-templates)/ooo.yml: base or template pipeline for opsman, standard product. each pipeline can be used standalone or can be merged into single pipeline via [merge-pipeline.sh](merge-pipeline.sh)
- [pipelines-generated](pipelines-generated)/ooo.yml: auto-generated temporary pipeline by [generate-pipeline.sh](generate-pipeline.sh) or [merge-pipeline.sh](merge-pipeline.sh)
- generate-pipeline.sh: this file generates a pipeline for each product from 'pipelines-templates/product-pipeline-template.yml'. you can edit this script to add all products to single pipeline 
- merge-pipelines.sh: merge all of single pipelines into a single pipeline named 'merged-platform-pipeline.yml'. you need to install aviator cli (https://github.com/herrjulz/aviator) before run this script. see detailed guide below to install aviator.
- [fly-pipeline.sh](fly-pipeline.sh): script to run `fly set-pipeline` with fly target alias and <foundation> name under foundations folder.

# How to setup platform pipeline for my foundation.
1) copy foundations/FOUNDATION folder to your iaas foundatio and configure files for your environment.
2) configure credhub values corresponding to foundations/FOUNDATION/
3) you may edit pipeline template as you wish from [pipelines-templates](pipelines-templates)
4) edit [generate-pipeline.sh](generate-pipeline.sh) to generate each pipeline for each products, such as 'healthwatch', 'redis', 'rabbitmq'
5) optionally optional you can merge jobs into single pipeline, then run [merge-pipeline.sh](merge-pipeline.sh) and it will generates [pipelines-generated/merged-platform-pipeline.yml](pipelines-generated/merged-platform-pipeline.yml). 
6) set pipeline via [fly-pipline.sh](fly-pipeline.sh) or fly cli for each pipeline under [pipelines-generated](pipelines-generated) where there is single or merged pipeline. copy [pipelines-templates/pipeline-params.yml](pipelines-templates/pipeline-params.yml) to 'pipeline-vars' folder and edit before run [fly-pipline.sh](fly-pipeline.sh)




# Detailed procedure to use this pipeline Guide.

## option1) use Tanzu opsmanager bosh to install concourse
- provides terraforming(public cloud only) toolkit for control-plane: VPC, subnet, LB, security group, DNS, domain certs, opsman
- will install opsman and bosh
- use opsman as jumpbox


## option2) use bbl (oss) to install concourse
- bbl include terraforming(private, public cloud) for control-plane
- will install jumpbox, OSS bosh.
- https://github.com/cloudfoundry/bosh-bootloader/blob/master/docs/howto-target-bosh-director.md
```
brew install bbl
brew upgrade cloudfoundry/tap/bbl
```


## install control-plane echos.
- install concourse
- install credhub
- prepare s3(aws,...)
- git(github, gitlab)

# (optional) install aviator cli (https://github.com/herrjulz/aviator)
```
wget -O /usr/local/bin/aviator https://github.com/JulzDiverse/aviator/releases/download/v1.7.0/aviator-darwin-amd64 && chmod +x /usr/local/bin/aviator
```

# (optional) prepare domain certs
- save to credhub or git

# (if public cloud) terraforming for platform 
- terraform toolkit for TAS, TKGi 
- save the terraform.tfstate to credhub
- [README-terraforming-control-plane-aws](README-terraforming-control-plane-aws.md)

# generate product pipeline file from template
- generated file can be used to any foundation.(iaas agnostic)
- install fly cli
- add product name to generate-pipeline.sh: (will be used as pipeline job name)
- generate-pipeline.sh: will remove all iles under ./pipelines-generated/ and generates

# merge pipeline files to single file.
- merge opsman, bosh, products, backup into single pipeline.

- merge-pipelines.sh: will generate ./pipelines-generated/merged-platform-pipeline.yml

# set pipeline
- update foundation config (git)
- login to concourse: fly login
- fly-pipeline.sh




