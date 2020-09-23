#!/bin/bash
## ref https://github.com/herrjulz/aviator#merge-array

./generate-pipeline.sh

echo "merging product pipelines from $PIPELINES_DIR"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PIPELINES_DIR=${SCRIPT_DIR}/pipelines-templates
GENERATED_DIR=${SCRIPT_DIR}/pipelines-generated

cp ${PIPELINES_DIR}/download-products.yml  ${GENERATED_DIR}/copied-download-products.yml
cp ${PIPELINES_DIR}/opsman-pipeline.yml  ${GENERATED_DIR}/copied-opsman-pipeline.yml
cp ${PIPELINES_DIR}/platform-backup-pipeline.yml  ${GENERATED_DIR}/copied-platform-backup-pipeline.yml

## list up job names from geneated file.
cat > ${GENERATED_DIR}/_groups.yml << EOF
groups:
- name: main
  jobs:
EOF

for filename in $GENERATED_DIR/*.yml; do
  #echo "$filename"
  sed -n '/^jobs:/,/^resource_types:/p' $filename | grep  "\- name" | sed 's/- name:/  -/g'  >> ${GENERATED_DIR}/_groups.yml
done




cat > ${PIPELINES_DIR}/aviator-merge-template-generated.yml << EOF
spruce:
- base: ${PIPELINES_DIR}/base-pipeline-template.yml
  merge:
  - with_in: ${GENERATED_DIR}/
  skip_non_existing: false
  to: ${GENERATED_DIR}/merged-platform-pipeline.yml
EOF


rm -rf ${GENERATED_DIR}/platform-pipeline-merged.yml
aviator -f ${PIPELINES_DIR}/aviator-merge-template-generated.yml
