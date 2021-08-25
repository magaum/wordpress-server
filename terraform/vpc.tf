data "aws_availability_zones" "azs" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "wordpress-vpc"
  cidr = var.cidr

  azs = [for az in data.aws_availability_zones.azs.names : az]

  public_subnets   = [cidrsubnet(var.cidr, 4, 0), cidrsubnet(var.cidr, 4, 1)]
  database_subnets = [cidrsubnet(var.cidr, 4, 4), cidrsubnet(var.cidr, 4, 5)]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  database_subnet_group_name             = "db-subnet"

  enable_vpn_gateway = false

  tags = {
    Environment = "dev"
  }
}
