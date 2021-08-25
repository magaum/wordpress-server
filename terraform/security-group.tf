module "mysql_security_group" {
  source              = "terraform-aws-modules/security-group/aws//modules/mysql"
  version             = "~> 4.0"
  name                = "Allow-database-access-from-vpc"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = [var.cidr]
}

module "http_80_security_group" {
  source              = "terraform-aws-modules/security-group/aws//modules/http-80"
  version             = "~> 4.0"
  vpc_id              = module.vpc.vpc_id
  name                = "Allow-http"
  ingress_cidr_blocks = ["0.0.0.0/0"]
}

module "ssh_security_group" {
  source              = "terraform-aws-modules/security-group/aws//modules/ssh"
  version             = "~> 4.0"
  vpc_id              = module.vpc.vpc_id
  name                = "Allow-ssh"
  ingress_cidr_blocks = ["0.0.0.0/0"] //TODO remover
}
