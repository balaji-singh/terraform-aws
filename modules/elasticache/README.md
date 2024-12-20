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
| [aws_elasticache_cluster.memcached](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_parameter_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.redis](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allowed_cidr_blocks"></a> [allowed\_cidr\_blocks](#input\_allowed\_cidr\_blocks) | List of CIDR blocks that are allowed to access the cache cluster | `list(string)` | `[]` | no |
| <a name="input_allowed_security_group_ids"></a> [allowed\_security\_group\_ids](#input\_allowed\_security\_group\_ids) | List of Security Group IDs that are allowed to access the cache cluster | `list(string)` | `[]` | no |
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | Whether to enable encryption at rest | `bool` | `true` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails | `bool` | `false` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | ID for the ElastiCache cluster | `string` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | Name of the cache engine to be used. Supported values are redis or memcached | `string` | `"redis"` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Version number of the cache engine | `string` | `"7.0"` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Specifies the weekly time range for when maintenance on the cache cluster is performed | `string` | `"sun:05:00-sun:06:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Specifies whether to enable Multi-AZ Support for the cluster | `bool` | `false` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The compute and memory capacity of the nodes | `string` | `"cache.t3.micro"` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | The initial number of cache nodes. For Redis, this value must be 1 | `number` | `1` | no |
| <a name="input_parameter_group_family"></a> [parameter\_group\_family](#input\_parameter\_group\_family) | The family of the ElastiCache parameter group | `string` | `"redis7"` | no |
| <a name="input_port"></a> [port](#input\_port) | The port number on which the cache accepts connections | `number` | `6379` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | The number of days for which ElastiCache will retain automatic cache cluster snapshots (Redis only) | `number` | `7` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | The daily time range during which automated backups are created (Redis only) | `string` | `"03:00-04:00"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC Subnet IDs for the cache subnet group | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | Whether to enable encryption in transit | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID to create the cluster in | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_address"></a> [cluster\_address](#output\_cluster\_address) | The DNS name of the ElastiCache cluster without the port appended |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the ElastiCache cluster |
| <a name="output_cluster_port"></a> [cluster\_port](#output\_cluster\_port) | The port number on which the cluster accepts connections |
| <a name="output_engine"></a> [engine](#output\_engine) | The cache engine used |
| <a name="output_engine_version"></a> [engine\_version](#output\_engine\_version) | The cache engine version used |
| <a name="output_parameter_group_id"></a> [parameter\_group\_id](#output\_parameter\_group\_id) | The ID of the parameter group |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | The ARN of the security group |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_subnet_group_id"></a> [subnet\_group\_id](#output\_subnet\_group\_id) | The ID of the subnet group |
<!-- END_TF_DOCS -->