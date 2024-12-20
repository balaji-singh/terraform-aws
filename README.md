# AWS EKS Terraform Module

This Terraform module creates an Amazon EKS (Elastic Kubernetes Service) cluster along with the necessary IAM roles and node groups.

## Features

- Creates an EKS cluster
- Sets up IAM roles and policies for the cluster and node groups
- Creates an EKS node group with customizable instance types and scaling options
- Configurable private/public endpoint access
- Customizable tags

## Usage

```hcl
module "eks" {
  source = "path/to/module"

  cluster_name    = "my-eks-cluster"
  kubernetes_version = "1.27"
  
  subnet_ids = [
    "subnet-xxxxxxxx",
    "subnet-yyyyyyyy"
  ]

  endpoint_private_access = true
  endpoint_public_access  = true

  node_desired_size = 2
  node_max_size     = 4
  node_min_size     = 1

  instance_types = ["t3.medium"]
  disk_size      = 20

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

## Requirements

- Terraform >= 1.0
- AWS Provider >= 4.0
- An existing VPC with subnets

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| cluster_name | Name of the EKS cluster | string | n/a | yes |
| kubernetes_version | Kubernetes version | string | "1.27" | no |
| subnet_ids | List of subnet IDs | list(string) | n/a | yes |
| endpoint_private_access | Enable private API endpoint | bool | false | no |
| endpoint_public_access | Enable public API endpoint | bool | true | no |
| node_desired_size | Desired number of worker nodes | number | 2 | no |
| node_max_size | Maximum number of worker nodes | number | 4 | no |
| node_min_size | Minimum number of worker nodes | number | 1 | no |
| instance_types | List of instance types for the node group | list(string) | ["t3.medium"] | no |
| disk_size | Disk size in GiB for worker nodes | number | 20 | no |
| tags | A map of tags to add to all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | The name/id of the EKS cluster |
| cluster_arn | The Amazon Resource Name (ARN) of the cluster |
| cluster_endpoint | The endpoint for the EKS control plane |
| cluster_security_group_id | Security group ID attached to the EKS cluster |
| cluster_certificate_authority_data | Base64 encoded certificate data for cluster |
| node_group_id | EKS node group ID |
| node_group_arn | Amazon Resource Name (ARN) of the EKS Node Group |

## License

MIT
