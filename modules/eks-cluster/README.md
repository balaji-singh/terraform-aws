<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eks_addon.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_addons"></a> [cluster\_addons](#input\_cluster\_addons) | List of EKS add-ons to enable | <pre>list(object({<br/>    name                    = string<br/>    version                 = optional(string)<br/>    resolve_conflicts       = optional(string)<br/>    service_account_role_arn = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_cluster_encryption_key_arn"></a> [cluster\_encryption\_key\_arn](#input\_cluster\_encryption\_key\_arn) | ARN of the KMS key used for cluster encryption | `string` | `null` | no |
| <a name="input_cluster_encryption_resources"></a> [cluster\_encryption\_resources](#input\_cluster\_encryption\_resources) | List of resources to encrypt. Valid values are secrets | `list(string)` | <pre>[<br/>  "secrets"<br/>]</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_role_arn"></a> [cluster\_role\_arn](#input\_cluster\_role\_arn) | ARN of the IAM role for the EKS cluster | `string` | n/a | yes |
| <a name="input_cluster_timeouts"></a> [cluster\_timeouts](#input\_cluster\_timeouts) | Timeout configurations for the cluster | <pre>object({<br/>    create = optional(string)<br/>    update = optional(string)<br/>    delete = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_enable_cluster_encryption"></a> [enable\_cluster\_encryption](#input\_enable\_cluster\_encryption) | Enable envelope encryption for cluster secrets | `bool` | `false` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | List of the desired control plane logging to enable | `list(string)` | <pre>[<br/>  "api",<br/>  "audit",<br/>  "authenticator",<br/>  "controllerManager",<br/>  "scheduler"<br/>]</pre> | no |
| <a name="input_endpoint_private_access"></a> [endpoint\_private\_access](#input\_endpoint\_private\_access) | Whether the Amazon EKS private API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_endpoint_public_access"></a> [endpoint\_public\_access](#input\_endpoint\_public\_access) | Whether the Amazon EKS public API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_ip_family"></a> [ip\_family](#input\_ip\_family) | The IP family used to assign Kubernetes pod and service addresses. Valid values are ipv4 and ipv6 | `string` | `"ipv4"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use for the EKS cluster | `string` | `"1.27"` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | List of modules or resources this module depends on | `list(any)` | `[]` | no |
| <a name="input_public_access_cidrs"></a> [public\_access\_cidrs](#input\_public\_access\_cidrs) | List of CIDR blocks that can access the Amazon EKS public API server endpoint | `list(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs for the EKS cluster | `list(string)` | `[]` | no |
| <a name="input_service_ipv4_cidr"></a> [service\_ipv4\_cidr](#input\_service\_ipv4\_cidr) | The CIDR block to assign Kubernetes service IP addresses from | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the EKS cluster | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_addons"></a> [cluster\_addons](#output\_cluster\_addons) | Map of enabled cluster add-ons and their status |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The Amazon Resource Name (ARN) of the cluster |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64 encoded certificate data required to communicate with the cluster |
| <a name="output_cluster_encryption_config"></a> [cluster\_encryption\_config](#output\_cluster\_encryption\_config) | Encryption configuration for the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint for the EKS control plane |
| <a name="output_cluster_iam_role_arn"></a> [cluster\_iam\_role\_arn](#output\_cluster\_iam\_role\_arn) | IAM role ARN of the EKS cluster |
| <a name="output_cluster_iam_role_name"></a> [cluster\_iam\_role\_name](#output\_cluster\_iam\_role\_name) | IAM role name of the EKS cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The name/id of the EKS cluster |
| <a name="output_cluster_platform_version"></a> [cluster\_platform\_version](#output\_cluster\_platform\_version) | Platform version of the cluster |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | Security group ID attached to the EKS cluster |
| <a name="output_cluster_status"></a> [cluster\_status](#output\_cluster\_status) | Status of the EKS cluster |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | The Kubernetes version of the cluster |
| <a name="output_cluster_vpc_config"></a> [cluster\_vpc\_config](#output\_cluster\_vpc\_config) | VPC configuration of the cluster |
| <a name="output_identity_oidc_issuer"></a> [identity\_oidc\_issuer](#output\_identity\_oidc\_issuer) | The OIDC Identity issuer for the cluster |
| <a name="output_identity_oidc_issuer_arn"></a> [identity\_oidc\_issuer\_arn](#output\_identity\_oidc\_issuer\_arn) | The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account |
<!-- END_TF_DOCS -->