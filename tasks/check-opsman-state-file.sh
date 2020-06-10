#!/bin/bash
## when create-vm, check if there is a config/state/state.yml on git and matches with 'vm_name' on configs/opsman.yml


##export STATE_FILE=../foundations/pez/state/state.yml
##export OPSMAN_CONFIG_FILE=../foundations/pez/opsman/opsman.yml
##export EXIT_IF_VM_EXIST_IN_STATE_FILE=false


state_file="config/$STATE_FILE"
if [[ ! -f $state_file ]]; then
  echo "OK, $state_file not exist"
  exit 0
fi
opsman_file="config/$OPSMAN_CONFIG_FILE"
if [[ ! -f $opsman_file ]]; then
  echo "Error, $opsman_file not exist"
  exit 1
fi

vm_name_from_opsman_file=`grep "vm_name" $opsman_file | awk -F':' '{print $2}' |sed 's/ //g'`
vm_name_from_opsman_file=`echo $vm_name_from_opsman_file | awk -F'#' '{print $1}'`
echo "vm_name: $vm_name_from_opsman_file"
if [ -z "$vm_name_from_opsman_file" ]; then
  echo "Error, $vm_name_from_opsman_file is empty"
  exit 1
fi

vm_id_from_state_file=`grep vm_id $state_file | awk -F'/' '{print $NF}' |sed 's/ //g'`
echo "vm_id: $vm_id_from_state_file"
if [ -z "$vm_id_from_state_file" ]; then
  echo "OK, $state_file is empty"
  exit 0
fi

if [ "$EXIT_IF_VM_EXIST_IN_STATE_FILE" == "true" ]; then
  echo "Warning, vm_id_from_state_file already exists: $vm_name_from_opsman_file"
  exit 1
fi

if [ "$vm_name_from_opsman_file" != "$vm_id_from_state_file" ]; then
   echo "Warning, vm_name mismatch  between $state_file and $opsman_file. check $state_file"
   exit 1
fi

echo "Ok, all good. vm_name between $state_file and $opsman_file matches"


