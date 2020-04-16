#!/usr/bin/env bash
# code_snippet download-product-script start bash

cat /var/version && echo ""
set -eux

if [ -z "$SOURCE" ]; then
  echo "No source was provided."
  echo "Please provide pivnet, s3, gcs, or azure."
  exit 1
fi

vars_files_args=("")
for vf in ${VARS_FILES}
do
  vars_files_args+=("--vars-file ${vf}")
done

# ${vars_files_args[@] needs to be globbed to pass through properly
# shellcheck disable=SC2068
om download-product \
   --config config/"${CONFIG_FILE}" ${vars_files_args[@]} \
   --output-directory downloaded-files \
   --source "$SOURCE"

{ printf "\nReading product details..."; } 2> /dev/null
# shellcheck disable=SC2068
product_slug=$(om interpolate \
  --config config/"${CONFIG_FILE}" ${vars_files_args[@]} \
  --path /pivnet-product-slug)

product_path=$(om interpolate \
  --config downloaded-files/download-file.json \
  --path /product_path)

stemcell_file=$(om interpolate \
  --config downloaded-files/download-file.json \
  --path /stemcell_path?)

echo $product_slug > downloaded-product/product_slug
echo $product_path > downloaded-product/product_path
echo $stemcell_file > downloaded-product/stemcell_file

echo $product_path  | awk -F '[/\[\]]' '{print $NF}' > downloaded-product/product_file

# code_snippet download-product-script end