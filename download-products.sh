
#!/bin/bash

if [ -z $1 ] || [ -z $2 ] ; then
    echo "!!! please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target] [foundation]"
	exit
fi	
FLY_TARGET=$1
FOUNDATION=$2


fly -t ${FLY_TARGET} sp -p "${FOUNDATION}-download-products" \
-c ./download-products.yml \
-v foundation=${FOUNDATION} \
-l ./envs/${FOUNDATION}/pipeline-vars/params.yml
