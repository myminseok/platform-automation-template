
#!/bin/bash

if [ -z $1 ] || [ -z $2 ] ; then
    echo "!!! please provide parameters"
	echo "${BASH_SOURCE[0]} [fly-target] [foundation]"
	exit
fi	
FLY_TARGET=$1
FOUNDATION=$2


fly -t ${FLY_TARGET} sp -p "${FOUNDATION}-manage-opsman" \
-c ./manage-opsman.yml \
-v foundation=${FOUNDATION} \
-v BUILD_PIPELINE_NAME="${FOUNDATION}-manage-opsman"  \
-l ./envs/${FOUNDATION}/pipeline-vars/params.yml
