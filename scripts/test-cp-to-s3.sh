## https://aws.amazon.com/cli/
#!/bin/bash

##setup aws credential first

aws s3 cp . s3://mkim-bbr-backup --recursive --exclude "*" --include "*.tar"
aws s3 ls  s3://mkim-bbr-backup