module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "wordpress-data"

  engine               = "mysql"
  engine_version       = "8.0.23"
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       = "db.t2.micro"

  allocated_storage       = 5 //GB
  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  name     = var.wordpress_database
  username = var.master_rds_user
  password = var.master_rds_user_password
  port     = "3306"

  iam_database_authentication_enabled = false

  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  vpc_security_group_ids = [module.mysql_security_group.security_group_id]
  subnet_ids             = module.vpc.database_subnets

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  tags = {
    Environment = "dev"
  }
}

output "db_endpoint" {
  description = "RDS endpoint to connect"
  value = split(":", module.db.db_instance_endpoint)[0]
}