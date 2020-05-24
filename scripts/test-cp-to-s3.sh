## https://aws.amazon.com/cli/
#!/bin/bash

aws s3 cp . s3://mkim-bbr-backup --recursive --exclude "*" --include "*.tar"
aws s3 ls  s3://mkim-bbr-backup