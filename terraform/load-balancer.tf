module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "wordpress-alb"

  load_balancer_type = "application"

  internal        = false
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets
  security_groups = [module.http_80_security_group.security_group_id]

  access_logs = {
    bucket = "web-server-alb-logs"
  }

  target_groups = [
    {
      name_prefix      = "wp-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = module.ec2_web_server.id[0]
          port      = 80
        }
      ]
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "Dev"
  }

  depends_on = [
    module.ec2_web_server,
    module.s3_bucket_alb
  ]
}

module "s3_bucket_alb" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "web-server-alb-logs"
  acl    = "log-delivery-write"

  force_destroy = true

  attach_elb_log_delivery_policy = true
  attach_lb_log_delivery_policy  = true
}

output "alb_public_ip" {
  value = module.alb.lb_dns_name
}