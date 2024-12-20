locals {
  environment = "dev"
  aws_region  = "ap-south-1"

  # VPC Configuration
  vpc_cidr = "10.0.0.0/16"
  azs      = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

  # Environment specific variables
  domain_name = "dev.example.com"

  # Cluster configuration
  cluster_name    = "dev-eks"
  cluster_version = "1.27"
  node_group_size = {
    min     = 1
    max     = 5
    desired = 3
  }

  # RDS configuration
  rds_instance_type = "db.t3.medium"
  rds_config = {
    engine         = "postgres"
    engine_version = "14.7"
    db_name        = "appdb"
    username       = "dbadmin"
  }

  # ElastiCache configuration
  cache_instance_type = "cache.t3.medium"
  cache_config = {
    engine          = "redis"
    engine_version  = "7.0"
    num_cache_nodes = 2
  }

  # Common tags
  tags = {
    Environment = "dev"
    Terraform   = "true"
    Project     = "infrastructure"
  }
}
