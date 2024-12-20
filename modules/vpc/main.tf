# ---------------------------------------------------------------------------------------------------------------------
# AWS VPC Configuration
# ---------------------------------------------------------------------------------------------------------------------

data "aws_availability_zones" "available" {
  state = "available"
}

# ---------------------------------------------------------------------------------------------------------------------
# Locals
# ---------------------------------------------------------------------------------------------------------------------

locals {
  tags = merge(
    var.tags,
    var.default_tags,
    {
      "terraform-module"    = "vpc"
      "terraform-workspace" = terraform.workspace
    },
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# VPC
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "main" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = merge(
    {
      Name                                        = "${var.cluster_name}-vpc"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    },
    local.tags
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Public Subnets
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name                                        = "${var.cluster_name}-public-${data.aws_availability_zones.available.names[count.index]}"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/elb"                    = "1"
      "Type"                                      = "Public Subnet"
    },
    local.tags
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Private Subnets
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = merge(
    {
      Name                                        = "${var.cluster_name}-private-${data.aws_availability_zones.available.names[count.index]}"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/internal-elb"           = "1"
      "Type"                                      = "Private Subnet"
    },
    local.tags
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Internet Gateway
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "${var.cluster_name}-igw"
    },
    local.tags
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# NAT Gateway
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_eip" "nat" {
  count  = length(var.private_subnets)
  domain = "vpc"

  tags = merge(
    {
      Name = "${var.cluster_name}-nat-eip-${count.index + 1}"
    },
    local.tags
  )
}

resource "aws_nat_gateway" "main" {
  count         = length(var.private_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {
      Name = "${var.cluster_name}-nat-${count.index + 1}"
    },
    local.tags
  )

  depends_on = [aws_internet_gateway.main]
}

# ---------------------------------------------------------------------------------------------------------------------
# Route Tables
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    {
      Name = "${var.cluster_name}-public-rt"
      Type = "Public Route Table"
    },
    local.tags
  )
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = merge(
    {
      Name = "${var.cluster_name}-private-rt-${count.index + 1}"
      Type = "Private Route Table"
    },
    local.tags
  )
}

# ---------------------------------------------------------------------------------------------------------------------
# Route Table Associations
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
