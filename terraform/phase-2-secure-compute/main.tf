provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.20.0.0/16"
  name     = "stc-p2-vpc"
}

module "nat" {
  source = "./modules/nat"

  vpc_id        = module.vpc.vpc_id
  public_subnet = module.vpc.public_subnets[0]
}

module "security_groups" {
  source = "./modules/security-groups"

  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"
}

module "flow_logs" {
  source = "./modules/flow-logs"

  vpc_id = module.vpc.vpc_id
}
