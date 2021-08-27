variable "cidr" {
  type        = string
  description = "VPC CIDR"
  default     = "10.0.0.0/22"
}

variable "amazon_linux" {
  type        = string
  description = "Amazon Linux 2 AMI (HVM) image"
  default     = "ami-0c2b8ca1dad447f8a"
}

variable "wordpress_database" {
  sensitive   = true
  type        = string
  description = "Database for wordpress"
  default = "wordpress"
}

variable "bastion_key_name" {
  sensitive = true
  type        = string
  description = "Bastion key pair name"
  default = "wordpress-lab"
}

variable "web_server_key_name" {
  sensitive = true
  type        = string
  description = "Web server key pair name"
  default = "wordpress-lab"
}

variable "wordpress_user" {
  sensitive   = true
  type        = string
  description = "User for wordpress database"
}

variable "wordpress_user_password" {
  sensitive   = true
  type        = string
  description = "Password for wordpress database user"
}

variable "master_rds_user" {
  sensitive   = true
  type        = string
  description = "Master DB user"
}

variable "master_rds_user_password" {
  sensitive   = true
  type        = string
  description = "Password for master DB user"
}
