#!/bin/bash -e
## inputs:
##  - FOUNDATION: any opsman deployment name alias (you name it)
##  - PRODUCT: product name to generate config template. matches product_name in versions.yml (you name it) eg: cf or tas.
##    om config-template will download under $PRODUCT
##  - ${IAAS}/${FOUNDATION}/products/versionså.yml -> mandatary, create inadvance
##  - ${IAAS}/${FOUNDATION}/opsfile/PRODUCT.yml -> optional, create inadvance
##  - export PIVNET_TOKEN= 
## output:
##  - generated-products/PRODUCT.yml
##  - generated-vars/PRODUCT.yml
##  - vars/PRODUCT.yml (emprty)


: ${PIVNET_TOKEN?"Need to set PIVNET_TOKEN"}

if [ ! $# -eq 2 ] ; then
    echo "${BASH_SOURCE[0]} FOUNDATION PRODUCT"
    exit
fi  

export FOUNDATION=$1
export PRODUCT=$2


SCRIPT_NAME=$(basename ${BASH_SOURCE[0]})
WORK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## TODO will not use IAAS at the moment
#foundation_config_path="$WORK_DIR/../${IAAS}/${FOUNDATION}"
foundation_config_path="$WORK_DIR/../${FOUNDATION}"

product_template_veresionfile="$foundation_config_path/products/versions.yml"

if [ ! -f ${product_template_veresionfile} ]; then
  echo "Prepare version file first under ${product_template_veresionfile}"
  exit 1
fi

version=$(bosh interpolate ${product_template_veresionfile} --path /products/$PRODUCT/product-version)
glob=$(bosh interpolate ${product_template_veresionfile} --path /products/$PRODUCT/pivnet-file-glob)
slug=$(bosh interpolate ${product_template_veresionfile} --path /products/$PRODUCT/pivnet-product-slug)
echo "FOUNDATION: $FOUNDATION"
echo "PRODUCT: $PRODUCT"
echo "version: $version"
echo "glob: $glob"
echo "slug: $slug"


download_template_main_path="$WORK_DIR/downloaded-tile-config-templates"
download_template_product_path="${download_template_main_path}/${PRODUCT}/${version}*"
echo "download_template_main_path: $download_template_main_path"

mkdir -p $download_template_main_path
if [ -f ${download_template_product_path}/product.yml ]; then
  echo ""
  echo "Skip Downloading product config template. already downloaded ${download_template_product_path}/product.yml"
else
  echo ""
  echo "Downloading product config template to ${download_template_main_path}"

  current_date="$( date +"%Y-%m-%d-%H-%M-%S" )"
  DOWNLOAD_TMP_DIR="$download_template_main_path/${current_date}"
  mkdir -p $DOWNLOAD_TMP_DIR
  pushd $DOWNLOAD_TMP_DIR
  
    echo "om config-template --output-directory=${DOWNLOAD_TMP_DIR} \
    --pivnet-api-token ${PIVNET_TOKEN} --pivnet-product-slug ${slug} \
    --product-version ${version} --pivnet-file-glob ${glob}"

    om config-template --output-directory=${DOWNLOAD_TMP_DIR} \
    --pivnet-api-token ${PIVNET_TOKEN} --pivnet-product-slug ${slug} \
    --product-version ${version} --pivnet-file-glob ${glob}
    
    ## mv all download template to the $PRODUCT folder. 
    ## this will allow any product ame in versions.yml. eg 'tas' instead of 'cf' 
    export download_product_name=$(echo * | awk '{print $1}')
    mkdir -p $download_template_main_path/${PRODUCT}
    mv $DOWNLOAD_TMP_DIR/${download_product_name}/* $download_template_main_path/${PRODUCT}/
  popd 
  rm -rf  $DOWNLOAD_TMP_DIR
fi

echo ""
echo "Generating configuration for product $PRODUCT"

product_template_opsfile="$foundation_config_path/opsfiles/${PRODUCT}-operations"

mkdir -p $foundation_config_path/opsfiles ## to prevent error
touch ${product_template_opsfile}

echo ""
echo "Checking pre-defined opsfile options to control config template ..."
export product_template_opsfile_args=("")
while IFS= read -r var; do
  product_template_opsfile_args+=("-o ${download_template_product_path}/${var}")
done < "${product_template_opsfile}"
echo " -> product_template_opsfile_args: ${product_template_opsfile_args[@]}"

echo ""
echo "Generating product template ... generated-products/${PRODUCT}.yml"
generated_product_template_path="$foundation_config_path/generated-products"
echo " -> $generated_product_template_path/${PRODUCT}.yml"
mkdir -p $generated_product_template_path
bosh int ${download_template_product_path}/product.yml \
 ${product_template_opsfile_args[@]} > $generated_product_template_path/${PRODUCT}.yml

echo ""
echo "Generating product default-vars ... generated-vars/${PRODUCT}.yml"
generated_product_template_vars_path="$foundation_config_path/generated-vars"
echo " -> $generated_product_template_vars_path/${PRODUCT}.yml"
mkdir -p $generated_product_template_vars_path
rm -rf $generated_product_template_vars_path/${PRODUCT}.yml
touch $generated_product_template_vars_path/${PRODUCT}.yml

if [ -f ${download_template_product_path}/default-vars.yml ]; then
  cat ${download_template_product_path}/default-vars.yml >> $generated_product_template_vars_path/${PRODUCT}.yml
fi
if [ -f ${download_template_product_path}/errand-vars.yml ]; then
  cat ${download_template_product_path}/errand-vars.yml  >> $generated_product_template_vars_path/${PRODUCT}.yml
fi
if [ -f ${download_template_product_path}/resource-vars.yml ]; then
  cat ${download_template_product_path}/resource-vars.yml >> $generated_product_template_vars_path/${PRODUCT}.yml
fi

mkdir -p $foundation_config_path/vars
touch $foundation_config_path/vars/${PRODUCT}.yml

echo "Complete"
