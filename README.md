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

## GitHub Actions Setup

This repository uses GitHub Actions for CI/CD with AWS authentication via OIDC (OpenID Connect). Follow these steps to set up the required AWS roles and permissions:

### 1. Create IAM OIDC Provider

```bash
# Get GitHub's OIDC provider thumbprint
aws iam create-open-id-connect-provider \
  --url https://token.actions.githubusercontent.com \
  --client-id-list sts.amazonaws.com \
  --thumbprint-list "6938fd4d98bab03faadb97b34396831e3780aea1"
```

### 2. Create IAM Role

Create a new file `github-actions-role.json`:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::<ACCOUNT_ID>:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:balaji-singh/terraform-aws:*"
                },
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}
```

Create the role:
```bash
aws iam create-role \
  --role-name github-actions-role \
  --assume-role-policy-document file://github-actions-role.json
```

### 3. Attach Required Policies

```bash
# Attach required policies (adjust according to your needs)
aws iam attach-role-policy \
  --role-name github-actions-role \
  --policy-arn arn:aws:iam::aws:policy/PowerUserAccess

# For more restricted permissions, create a custom policy instead
```

### 4. Configure GitHub Repository

1. Go to your repository settings
2. Navigate to Settings → Secrets and variables → Actions
3. Add the following secrets:
   - `AWS_ROLE_ARN`: The ARN of the role created above (format: `arn:aws:iam::<ACCOUNT_ID>:role/github-actions-role`)

### 5. Workflow Configuration

The GitHub Actions workflow is already configured in `.github/workflows/terraform.yml` to use OIDC authentication. Key configurations:

```yaml
- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
    aws-region: ${{ env.AWS_REGION }}
```

### Security Considerations

1. The OIDC provider establishes trust between GitHub and AWS
2. No long-term credentials are stored in GitHub
3. Role assumption is limited to specific repository and branches
4. Token lifetime is limited to the workflow run duration
5. Use least privilege permissions in the IAM role

### Troubleshooting

1. Verify the OIDC provider is correctly configured:
```bash
aws iam list-open-id-connect-providers
```

2. Check the role trust relationship:
```bash
aws iam get-role --role-name github-actions-role
```

3. Verify the role has the required permissions:
```bash
aws iam list-attached-role-policies --role-name github-actions-role
