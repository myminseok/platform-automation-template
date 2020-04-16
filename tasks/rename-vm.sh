#!/usr/bin/env bash

## https://github.com/pivotal-cf/vsphere-patch-hosts-pipeline/blob/master/tasks/patch/task.sh
#export GOVC_URL=https://
#export GOVC_DATACENTER=
#export GOVC_INSECURE=1
#export GOVC_USERNAME=
#export GOVC_PASSWORD=



echo "GOVC_URL:$GOVC_URL"
echo "GOVC_DATACENTER:$GOVC_DATACENTER"
echo "GOVC_USERNAME:$GOVC_USERNAME"

# govc find . -type m
# govc find  vm -name ops*


vm_ipath=`awk -F'[ :]' '/vm_id/ {gsub("[{}\"]", "", $5); print $5}' ./state/${STATE_FILE}`
echo "vm_ipath: $vm_ipath \n"
govc vm.info -vm.ipath=${vm_ipath}


vm_name=`echo $vm_ipath | awk -F'[/]' '{print $NF}'`
new_vm_name="${vm_name}_${VM_RENAME_POSTFIX}"

echo "govc vm.change -vm.ipath=${vm_ipath} -name=$new_vm_name"
govc vm.change -vm.ipath=${vm_ipath} -name=$new_vm_name

govc vm.info -vm.ipath=${vm_ipath}
