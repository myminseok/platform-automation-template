#!/usr/bin/env bash
# code_snippet credhub_interpolate-script start bash

cat /var/version && echo ""
set -euo pipefail




# NOTE: The credhub cli does not ignore empty/null environment variables.
# https://github.com/cloudfoundry-incubator/credhub-cli/issues/68
if [ -z "$CREDHUB_CA_CERT" ]; then
  unset CREDHUB_CA_CERT
  export SKIP_TLS_VALIDATION="--skip-tls-validation" ##!!! added from original version 
fi


##!!! modified from original version 
credhub login -s $CREDHUB_SERVER --client-name=$CREDHUB_CLIENT --client-secret=$CREDHUB_SECRET $SKIP_TLS_VALIDATION
credhub find


if [ -z "$PREFIX" ]; then
  echo "Please specify a PREFIX. It is required."
  exit 1
fi


# $INTERPOLATION_PATHS needs to be globbed to read multiple files
# shellcheck disable=SC2086
files=$(cd files && find $INTERPOLATION_PATHS -type f -name '*.y*ml' -follow) ##!!! modified from original version :'*.y*ml'

if [ "$SKIP_MISSING" == "true" ]; then
  export SKIP_MISSING="--skip-missing"
else
  export SKIP_MISSING=""
fi


for file in $files; do
  echo "interpolating files/$file"
  mkdir -p interpolated-files/"$(dirname "$file")"
  credhub interpolate --prefix "$PREFIX" \
  --file files/"$file" ${SKIP_MISSING} \
  > interpolated-files/"$file"
done

# code_snippet credhub_interpolate-script end
