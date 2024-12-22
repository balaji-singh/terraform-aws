# AWS Infrastructure as Code with Terraform

This repository contains Terraform modules and configurations for deploying and managing AWS infrastructure components using Infrastructure as Code (IaC) principles.

## Repository Structure

```
.
├── bootstrap/          # Bootstrap configurations
├── compositions/       # Reusable infrastructure compositions
├── config/            # Configuration files
├── env/              # Environment-specific configurations
│   └── dev/          # Development environment
├── modules/          # Reusable Terraform modules
│   ├── eks-cluster/     # EKS cluster module
│   ├── eks-node-group/  # EKS node group module
│   ├── elasticache/     # ElastiCache module
│   ├── iam-roles/       # IAM roles and policies
│   ├── msk/             # Managed Streaming for Kafka
│   ├── rds/             # RDS database module
│   ├── s3/              # S3 bucket module
│   ├── security-groups/ # Security groups module
│   ├── ssm/             # Systems Manager module
│   ├── vpc/             # VPC networking module
│   └── waf/             # Web Application Firewall module
└── scripts/           # Utility scripts
```

## Available Modules

This repository includes the following AWS infrastructure modules:

### Networking
- **VPC** (`vpc/`): 
  - Complete networking setup with public/private subnets
  - NAT Gateways for private subnet internet access
  - Custom route tables and network ACLs
  - VPC endpoints for AWS services

### Container & Orchestration
- **EKS Cluster** (`eks-cluster/`):
  - Managed Kubernetes control plane setup
  - OIDC provider integration
  - Cluster security group configuration
  - Kubernetes API endpoint management

- **EKS Node Group** (`eks-node-group/`):
  - Auto-scaling worker node groups
  - Custom launch templates
  - Node IAM role configuration
  - Spot instance support

### Database & Caching
- **RDS** (`rds/`):
  - Managed relational databases (MySQL, PostgreSQL)
  - Multi-AZ deployment options
  - Automated backups and maintenance windows
  - Parameter group customization

- **ElastiCache** (`elasticache/`):
  - Redis/Memcached clusters
  - Multi-AZ replication groups
  - Automatic failover configuration
  - Subnet group management

### Messaging & Streaming
- **MSK** (`msk/`):
  - Managed Kafka clusters
  - Multi-AZ broker deployment
  - Custom configuration settings
  - Security group management

### Security & Access Control
- **WAF** (`waf/`):
  - Web Application Firewall rules
  - SQL injection protection
  - Rate limiting rules
  - Geographic restrictions

- **IAM Roles** (`iam-roles/`):
  - Service-linked roles
  - Cross-account access policies
  - Least privilege permissions
  - Resource-based policies

- **Security Groups** (`security-groups/`):
  - Granular network access controls
  - Service-specific rule sets
  - Dynamic security group references
  - Egress rules management

### Management & Monitoring
- **SSM** (`ssm/`):
  - Systems Manager parameter store
  - Secure string parameter management
  - Parameter hierarchies
  - Cross-account parameter sharing

### Storage
- **S3** (`s3/`):
  - Bucket creation and configuration
  - Versioning and lifecycle rules
  - Server-side encryption
  - Cross-region replication setup

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS Provider >= 4.0

## Usage

1. Clone the repository:
```bash
git clone https://github.com/balaji-singh/terraform-aws.git
```

2. Navigate to the desired environment directory:
```bash
cd env/dev
```

3. Initialize Terraform:
```bash
terraform init
```

4. Review the planned changes:
```bash
terraform plan
```

5. Apply the changes:
```bash
terraform apply
```

## Environment Configuration

The `env/` directory contains environment-specific configurations. Each environment (e.g., dev, staging, prod) can have its own configuration values while using the same underlying modules.

## Module Documentation

Each module in the `modules/` directory contains its own README with detailed configuration options and usage examples. Refer to individual module documentation for specific configuration options.

## Make Commands

The repository includes several make commands to help manage the infrastructure. You can use these commands with optional environment variables `ENV` (default: dev) and `COMPONENT`.

### Core Infrastructure Commands

```bash
# Initialize Terraform/Terragrunt for all components
make init

# Plan changes for all components
make plan

# Apply changes for all components
make apply

# Destroy all components
make destroy
```

### Development Commands

```bash
# Format Terraform and Terragrunt files
make fmt

# Validate Terraform configurations
make validate

# Generate documentation
make docs

# Run tests
make test

# Run security scans (tfsec, checkov, terrascan)
make security-scan

# Clean all temporary Terraform files
make clean
```

### Helper Commands

```bash
# Initialize, format, validate, and generate docs
make init-all

# List all available workspaces
make list-workspaces

# Generate cost estimates using Infracost
make cost-estimate
```

### Using with Specific Environments

You can specify the environment using the `ENV` variable:

```bash
# Plan changes for production environment
make plan ENV=prod

# Apply changes for staging environment
make apply ENV=staging
```

### Prerequisites for Make Commands

Ensure you have the following tools installed:
- Terraform
- Terragrunt
- tfsec
- checkov
- terrascan
- infracost (for cost estimation)
- Go (for running tests)