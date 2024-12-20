locals {
  aws_region = "ap-south-1"

  # Region specific variables
  azs = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

  # VPC CIDR for this region
  vpc_cidr = "10.0.0.0/16"
}
