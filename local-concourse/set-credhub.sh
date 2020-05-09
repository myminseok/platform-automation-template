
credhub api --server=https://localhost:9000/ --skip-tls-validation
credhub login  --client-name=credhub_client --client-secret=secret
credhub set -t value -n /concourse/main/hello-credhub/hello -v test
