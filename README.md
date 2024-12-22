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

- **VPC**: Network infrastructure setup
- **EKS**: Elastic Kubernetes Service cluster and node groups
- **RDS**: Relational Database Service configurations
- **ElastiCache**: In-memory caching service
- **MSK**: Managed Streaming for Kafka
- **WAF**: Web Application Firewall rules
- **IAM**: Identity and Access Management roles and policies
- **Security Groups**: Network security configurations
- **SSM**: Systems Manager configurations
- **S3**: Simple Storage Service bucket configurations

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

