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
| [aws_eks_node_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_release_version"></a> [ami\_release\_version](#input\_ami\_release\_version) | AMI version of the EKS Node Group | `string` | `null` | no |
| <a name="input_ami_type"></a> [ami\_type](#input\_ami\_type) | Type of Amazon Machine Image (AMI) associated with the EKS Node Group | `string` | `"AL2_x86_64"` | no |
| <a name="input_capacity_type"></a> [capacity\_type](#input\_capacity\_type) | Type of capacity associated with the EKS Node Group. Valid values: ON\_DEMAND, SPOT | `string` | `"ON_DEMAND"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_desired_size"></a> [desired\_size](#input\_desired\_size) | Desired number of worker nodes | `number` | `2` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Disk size in GiB for worker nodes | `number` | `20` | no |
| <a name="input_ec2_ssh_key"></a> [ec2\_ssh\_key](#input\_ec2\_ssh\_key) | EC2 Key Pair name that provides access for SSH communication with the worker nodes | `string` | `null` | no |
| <a name="input_instance_types"></a> [instance\_types](#input\_instance\_types) | List of instance types associated with the EKS Node Group | `list(string)` | <pre>[<br/>  "t3.medium"<br/>]</pre> | no |
| <a name="input_launch_template_name"></a> [launch\_template\_name](#input\_launch\_template\_name) | Name of the launch template | `string` | `null` | no |
| <a name="input_launch_template_version"></a> [launch\_template\_version](#input\_launch\_template\_version) | Version of the launch template | `string` | `null` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum number of worker nodes | `number` | `4` | no |
| <a name="input_max_unavailable"></a> [max\_unavailable](#input\_max\_unavailable) | Maximum number of nodes unavailable at once during a version update | `number` | `1` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum number of worker nodes | `number` | `1` | no |
| <a name="input_module_depends_on"></a> [module\_depends\_on](#input\_module\_depends\_on) | List of modules or resources this module depends on | `list(any)` | `[]` | no |
| <a name="input_node_group_name"></a> [node\_group\_name](#input\_node\_group\_name) | Name of the EKS node group | `string` | n/a | yes |
| <a name="input_node_labels"></a> [node\_labels](#input\_node\_labels) | Key-value mapping of Kubernetes labels for EKS managed node groups | `map(string)` | `{}` | no |
| <a name="input_node_role_arn"></a> [node\_role\_arn](#input\_node\_role\_arn) | ARN of the IAM role for the EKS node group | `string` | n/a | yes |
| <a name="input_source_security_group_ids"></a> [source\_security\_group\_ids](#input\_source\_security\_group\_ids) | Set of EC2 Security Group IDs to allow SSH access from on the worker nodes | `list(string)` | `[]` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of subnet IDs for the EKS node group | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | `{}` | no |
| <a name="input_taint_effect"></a> [taint\_effect](#input\_taint\_effect) | Effect for the taint | `string` | `""` | no |
| <a name="input_taint_key"></a> [taint\_key](#input\_taint\_key) | Key for the taint | `string` | `""` | no |
| <a name="input_taint_value"></a> [taint\_value](#input\_taint\_value) | Value for the taint | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_node_group_arn"></a> [node\_group\_arn](#output\_node\_group\_arn) | Amazon Resource Name (ARN) of the EKS Node Group |
| <a name="output_node_group_id"></a> [node\_group\_id](#output\_node\_group\_id) | EKS node group ID |
| <a name="output_node_group_labels"></a> [node\_group\_labels](#output\_node\_group\_labels) | Map of Kubernetes labels applied to the nodes |
| <a name="output_node_group_resources"></a> [node\_group\_resources](#output\_node\_group\_resources) | List of objects containing information about underlying resources of the EKS Node Group |
| <a name="output_node_group_scaling_config"></a> [node\_group\_scaling\_config](#output\_node\_group\_scaling\_config) | Scaling configuration details of the EKS Node Group |
| <a name="output_node_group_status"></a> [node\_group\_status](#output\_node\_group\_status) | Status of the EKS Node Group |
| <a name="output_node_group_taints"></a> [node\_group\_taints](#output\_node\_group\_taints) | List of Kubernetes taints applied to the nodes |
<!-- END_TF_DOCS -->