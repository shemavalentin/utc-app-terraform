// The module has been created in network folder under modules/network and it is being called here to create the VPC and subnets for the application. 
//The module takes in variables such as VPC CIDR, subnet CIDRs, and availability zones to create the necessary network resources.

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Invoke the VPC Module
module "vpc" {
  source = "../../../modules/network"

  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  # Expand or shrink these arrays to change the number of subnets
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]

  # Set true for Dev/Staging (saves ~$32/mo per missing NAT), false for Multi-AZ High Availability
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Project     = "3-tier-app"
    ManagedBy   = "Terraform"
  }
}

// Invoke the Security Groups Module

module "security_groups" {
  source = "../../../modules/security"

  vpc_id       = module.vpc.vpc_id
  project_name = "3-tier-app"
  app_port     = 8080
  db_port      = 3306

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

module "alb" {
  source = "../../../modules/alb"

  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_security_group_id

  # ACM Certificate Domain (can be wildcard)
  domain_name = "*.seniorllmops.com"

  # Route 53 Base Hosted Zone (MUST NOT have wildcard)
  hosted_zone_domain = "seniorllmops.com"

  app_port          = 8080
  health_check_path = "/health"
  project_name      = "3-tier-app"

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Provider configuration for us-east-1 (Required for CloudFront ACM lookup)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# CDN Module Invocation
module "cdn" {
  source = "../../../modules/cdn"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  alb_dns_name = module.alb.alb_dns_name

  # 1. ACM Certificate domain (wildcard string as issued in ACM)
  domain_name = "*.seniorllmops.com"

  # 2. Route 53 Zone domain (apex domain ONLY - NO wildcard)
  hosted_zone_domain = "seniorllmops.com"

  project_name = "3-tier-app"

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

// Invoke the Auto Scaling Group Module

module "asg" {
  source = "../../../modules/asg"

  project_name          = "3-tier-app"
  private_subnet_ids    = module.vpc.private_subnet_ids
  app_security_group_id = module.security_groups.app_security_group_id
  target_group_arn      = module.alb.target_group_arn

  instance_type    = "t3.micro"
  min_size         = 2
  max_size         = 4
  desired_capacity = 2

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

// Invoke the RDS Module

module "rds" {
  source = "../../../modules/rds"

  project_name         = "3-tier-app"
  private_subnet_ids   = module.vpc.private_subnet_ids
  db_security_group_id = module.security_groups.db_security_group_id

  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t4g.micro"
  
  db_name     = "utcappdb"
  db_username = "utcadmin"
  db_password = var.db_password # Pass via terraform.tfvars or TF_VAR_db_password

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  multi_az                = false # Set to true for production

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}