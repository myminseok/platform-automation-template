#!/bin/bash

fly targets

if [ -z $1 ]  ; then
    echo "please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target]"
	exit
fi	

FLY_TARGET=$1

fly -t ${FLY_TARGET} login -u test -p test -c http://localhost:8081  -k

