variable "cluster_name" {
  description = "Name of the MSK cluster"
  type        = string
}

variable "kafka_version" {
  description = "Version of Apache Kafka"
  type        = string
  default     = "2.8.1"
}

variable "number_of_broker_nodes" {
  description = "Number of broker nodes in the cluster"
  type        = number
  default     = 3
}

variable "broker_instance_type" {
  description = "Instance type for the broker nodes"
  type        = string
  default     = "kafka.t3.small"
}

variable "broker_volume_size" {
  description = "Size of the EBS volume for broker nodes (in GiB)"
  type        = number
  default     = 100
}

variable "subnet_ids" {
  description = "List of subnet IDs for the broker nodes"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "allowed_security_group_ids" {
  description = "List of security group IDs allowed to connect to MSK"
  type        = list(string)
  default     = []
}

variable "kms_key_arn" {
  description = "ARN of KMS key for encryption at rest"
  type        = string
  default     = null
}

variable "client_broker_encryption" {
  description = "Encryption setting for client-broker communication"
  type        = string
  default     = "TLS"
}

variable "auto_create_topics_enable" {
  description = "Enable auto creation of topics"
  type        = bool
  default     = false
}

variable "default_replication_factor" {
  description = "Default replication factor for automatically created topics"
  type        = number
  default     = 3
}

variable "min_insync_replicas" {
  description = "Minimum number of in-sync replicas"
  type        = number
  default     = 2
}

variable "num_partitions" {
  description = "Default number of partitions for automatically created topics"
  type        = number
  default     = 3
}

variable "log_retention_days" {
  description = "Number of days to retain broker logs in CloudWatch"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
