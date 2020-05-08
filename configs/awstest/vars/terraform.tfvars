## https://docs.pivotal.io/platform/ops-manager/2-9/aws/prepare-env-terraform.html
## https://github.com/pivotal/paving/


env_name           = "awstest"
access_key         = "YOUR-ACCESS-KEY"
secret_key         = "YOUR-SECRET-KEY"
region             = "ap-northeast-2"
availability_zones = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
ops_manager_ami    = "YOUR-OPS-MAN-IMAGE-AMI"
dns_suffix         = "awstest.pcfdemo.net."

# *.sys.awstest.pcfdemo.net,*apps.awstest.pcfdemo.net,*.login.sys.awstest.pcfdemo.net,*.uaa.sys.awstest.pcfdemo.net,
ssl_cert = <<SSL_CERT
-----BEGIN CERTIFICATE-----
YOUR-CERTIFICATE
-----END CERTIFICATE-----
SSL_CERT

ssl_private_key = <<SSL_KEY
-----BEGIN EXAMPLE RSA PRIVATE KEY-----
YOUR-PRIVATE-KEY
-----END EXAMPLE RSA PRIVATE KEY-----
SSL_KEY


rds_instance_count = 1
rds_db_username = "YOUR-DATABASE-NAME"