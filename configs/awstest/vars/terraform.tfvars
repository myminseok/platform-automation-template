## https://docs.pivotal.io/platform/ops-manager/2-9/aws/prepare-env-terraform.html
## https://github.com/pivotal/paving/


env_name           = "mkimtest"
region             = "ap-northeast-2"
availability_zones = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
ops_manager_ami    = "YOUR-OPS-MAN-IMAGE-AMI"
dns_suffix         = "pcfdemo.net"

# *.sys.mkimtest.pcfdemo.net,*apps.mkimtest.pcfdemo.net,*.login.sys.mkimtest.pcfdemo.net,*.uaa.sys.mkimtest.pcfdemo.net,

vpc_cidr           = "10.0.0.0/16"
use_route53        = true
use_ssh_routes     = true
use_tcp_routes     = false


rds_instance_count = 1
rds_db_username = "mkimtest"

tags = {
    Project = "mkimtest"
}