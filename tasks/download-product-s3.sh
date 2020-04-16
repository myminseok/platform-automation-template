#!/usr/bin/env bash
# code_snippet download-product-s3-script start bash

## moving big files is slow. this file doesn't move. and will use 'downloaded-files' as it is


cat /var/version && echo ""
set -eux

echo "DEPRECATION NOTICE:"
echo "The download-product-s3 task will be replaced with the download-product task."
echo "That task will support the SOURCE param for downloading from pivnet, s3, gcs, or azure."

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
   --source s3

product_file=$(om interpolate \
--config downloaded-files/download-file.json \
--path /product_path)

stemcell_file=$(om interpolate \
  --config downloaded-files/download-file.json \
  --path /stemcell_path?)

#cp "$product_file" downloaded-product
#rm -rf downloaded-product
#ln -s downloaded-files downloaded-product 

if [ -e "$stemcell_file" ]; then
  mv "$stemcell_file" downloaded-stemcell
fi

if [ -e downloaded-files/assign-stemcell.yml ]; then
  mv downloaded-files/assign-stemcell.yml assign-stemcell-config/config.yml
fi
# code_snippet download-product-s3-script end
