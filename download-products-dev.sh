#!/bin/bash

if [ -z $1 ] ; then
    echo "!!! please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target]"
	exit
fi	
FLY_TARGET=$1

./download-products.sh ${FLY_TARGET} dev