terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

locals {
  region = "us-east-1"
}


provider "aws" {
  region = local.region
}
