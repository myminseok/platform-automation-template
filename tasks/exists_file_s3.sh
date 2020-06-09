#!/bin/bash

cat /var/version && echo ""
set -eux


##root@20ce9bf8-a5c5-4a07-68d8-03b4fcbd92e1:/tmp/build/876bc1e4/downloaded-files# ll
##-rw-r--r-- 1 root root 5884313600 Apr  3 09:22 '[ops-manager,2.8.5]ops-manager-vsphere-2.8.5-build.234.ova'
##-rw-r--r-- 1 root root        150 Apr  3 14:17  download-file.json
##-rw-r--r-- 1 root root 5884313600 Apr  3 07:45  ops-manager-vsphere-2.8.5-build.234.ova
##root@20ce9bf8-a5c5-4a07-68d8-03b4fcbd92e1:/tmp/build/876bc1e4/downloaded-files# cat download-file.json
## {"product_path":"downloaded-files/[ops-manager,2.8.5]ops-manager-vsphere-2.8.5-build.234.ova","product_slug":"ops-manager","product_version":"2.8.5"}

cat downloaded-product/product_path
cat downloaded-product/product_file
cat downloaded-product/product_slug

export filename=`cat downloaded-product/product_file`

#export endpoint=http://10.10.10.203:9000
#export secret_access_key=
#export access_key_id=
#export bucket=pivnet-products
echo $endpoint
echo $access_key_id
echo $bucket
echo $secret_access_key 



# apt install awscli -y
rm -rf ~/.aws
mkdir ~/.aws
echo "[default]" > ~/.aws/credentials
echo "s3_access_key_id = $access_key_id" >> ~/.aws/credentials
echo "s3_secret_access_key = $secret_access_key" >> ~/.aws/credentials
cat ~/.aws/credentials
chmod 400 ~/.aws/credentials
aws --endpoint $endpoint s3 ls s3://$bucket

count=`aws --endpoint $endpoint s3 ls s3://$bucket | grep $filename | grep -v grep | wc -l`

if [ "$count" != 0 ]; then 
  echo " found $filename"; 
  exit 1;
else 
  echo "not found"
  exit 0;
fi
