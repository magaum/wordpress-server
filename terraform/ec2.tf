module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  name                        = "wordpress-server"
  instance_count              = 1
  ami                         = var.amazon_linux
  instance_type               = "t2.micro"
  monitoring                  = true
  associate_public_ip_address = true
  key_name                    = "ec2-lab"
  vpc_security_group_ids = [
    module.http_80_security_group.security_group_id,
    module.ssh_security_group.security_group_id
  ]
  subnet_ids = module.vpc.public_subnets

  user_data = data.template_file.wordpress_setup.rendered

  tags = {
    Environment = "dev"
  }
}

output "ecs_public_address" {
  value = module.ec2_cluster.public_dns
}

data "template_file" "wordpress_setup" {
  template = file("${path.module}/scripts/wordpress.sh")
  vars = {
    wordpress_database       = var.wordpress_database
    wordpress_user           = var.wordpress_user
    wordpress_user_password  = var.wordpress_user_password
    master_rds_user          = var.master_rds_user
    master_rds_user_password = var.master_rds_user_password
    host                     = split(":", module.db.db_instance_endpoint)[0]
  }
}
