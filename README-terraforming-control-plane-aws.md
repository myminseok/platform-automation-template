 
pivotal-cf-terraforming-aws-73eecd4 cat modules/ops_manager/security_group.tf
data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
resource "aws_security_group" "ops_manager_security_group" {
  name        = "ops_manager_security_group"
  description = "Ops Manager Security Group"
  vpc_id      = "${var.vpc_id}"

  ingress {
    cidr_blocks = ["${var.private ? var.vpc_cidr : "${chomp(data.http.myip.body)}/32"}"]




## terraforming-control-plane

terraform < v0.12.0

*.awstest.pcfdemo.net인증서 : generate.

vi terraform.tfvars


./plan.sh

./apply.sh


om -e env.yml configure-authentication -c auth.yml

pivotal-cf-terraforming-aws-73eecd4 ./scripts/ssh terraforming-control-plane


https://github.com/pivotal-cf/texplate/releases
wget https://github.com/pivotal-cf/texplate/releases/download/v0.3.0/texplate_darwin_amd64
sudo mv to /usr/loca/bin/texplate


export PROJECT_DIR=????

 pivotal-cf-terraforming-aws-73eecd4 ./scripts/configure-director terraforming-control-plane Changeme1!


➜  terraforming-control-plane om -e env.yml staged-director-config --no-redact > control-plane-director-2.10.yml
