terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

module "ec2" {
    source = "./ec2"
    subnet_id = module.network.subnet_id
    securityGroup_id = module.network.securityGroup_id
}

module "network" {
    source = "./network"
}

module "cloudwatch" {
    source = "./cloudwatch"
    ec2_instance = module.ec2.ec2_instance
}

