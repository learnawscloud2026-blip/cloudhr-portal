locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

module "vpc" {
  source = "../../modules/vpc"

  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr

  common_tags = local.common_tags
}

module "subnet" {

  source = "../../modules/subnet"

  vpc_id = module.vpc.vpc_id

  project_name = var.project_name

  environment = var.environment

  common_tags = local.common_tags

  subnets = {

    public-a = {
      cidr_block              = "10.0.1.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = true
    }

    public-b = {
      cidr_block              = "10.0.2.0/24"
      availability_zone       = "us-east-1b"
      map_public_ip_on_launch = true
    }

    private-app-a = {
      cidr_block              = "10.0.11.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
    }

    private-app-b = {
      cidr_block              = "10.0.12.0/24"
      availability_zone       = "us-east-1b"
      map_public_ip_on_launch = false
    }

    private-db-a = {
      cidr_block              = "10.0.21.0/24"
      availability_zone       = "us-east-1a"
      map_public_ip_on_launch = false
    }

    private-db-b = {
      cidr_block              = "10.0.22.0/24"
      availability_zone       = "us-east-1b"
      map_public_ip_on_launch = false
    }

  }

}

module "internet_gateway" {

  source = "../../modules/internet-gateway"

  vpc_id = module.vpc.vpc_id

  project_name = var.project_name

  environment = var.environment

  common_tags = local.common_tags

}

module "elastic_ip" {

  source = "../../modules/elastic-ip"

  project_name = var.project_name

  environment = var.environment

  common_tags = local.common_tags

}

module "nat_gateway" {

  source = "../../modules/nat-gateway"

  allocation_id = module.elastic_ip.allocation_id

  public_subnet_id = module.subnet.subnet_ids["public-a"]

  project_name = var.project_name

  environment = var.environment

  common_tags = local.common_tags

}

module "route_table" {

  source = "../../modules/route-table"

  vpc_id = module.vpc.vpc_id

  internet_gateway_id = module.internet_gateway.internet_gateway_id

  nat_gateway_id = module.nat_gateway.nat_gateway_id

  subnet_ids = module.subnet.subnet_ids

  project_name = var.project_name

  environment = var.environment

  common_tags = local.common_tags
}

module "security_group" {

  source = "../../modules/security-group"

  vpc_id = module.vpc.vpc_id

  project_name = var.project_name

  environment = var.environment

  common_tags = local.common_tags

  my_ip = var.my_ip

}

module "iam" {

  source = "../../modules/iam"

  project_name = var.project_name

  environment = var.environment

  common_tags = local.common_tags

}

module "ecr" {

  source = "../../modules/ecr"

  project_name = var.project_name

  environment = var.environment

  common_tags = local.common_tags

}