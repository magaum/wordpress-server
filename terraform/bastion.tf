module "ec2_bastion" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name                        = "bastion"
  instance_count              = 1
  ami                         = var.amazon_linux
  instance_type               = "t2.micro"
  monitoring                  = true
  associate_public_ip_address = true
  key_name                    = var.bastion_key_name
  vpc_security_group_ids = [
    module.bastion_ssh_security_group.security_group_id
  ]
  subnet_ids = module.vpc.public_subnets

  tags = {
    Environment = "dev"
  }
}

output "bastion_ec2_public_address" {
  value = module.ec2_bastion.public_dns
}
