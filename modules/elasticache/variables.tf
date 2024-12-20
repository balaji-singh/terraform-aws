variable "cluster_id" {
  description = "ID for the ElastiCache cluster"
  type        = string
}

variable "engine" {
  description = "Name of the cache engine to be used. Supported values are redis or memcached"
  type        = string
  default     = "redis"

  validation {
    condition     = contains(["redis", "memcached"], var.engine)
    error_message = "Engine must be either 'redis' or 'memcached'."
  }
}

variable "engine_version" {
  description = "Version number of the cache engine"
  type        = string
  default     = "7.0"
}

variable "node_type" {
  description = "The compute and memory capacity of the nodes"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  description = "The initial number of cache nodes. For Redis, this value must be 1"
  type        = number
  default     = 1
}

variable "parameter_group_family" {
  description = "The family of the ElastiCache parameter group"
  type        = string
  default     = "redis7"
}

variable "port" {
  description = "The port number on which the cache accepts connections"
  type        = number
  default     = 6379
}

variable "vpc_id" {
  description = "VPC ID to create the cluster in"
  type        = string
}

variable "subnet_ids" {
  description = "List of VPC Subnet IDs for the cache subnet group"
  type        = list(string)
}

variable "allowed_security_group_ids" {
  description = "List of Security Group IDs that are allowed to access the cache cluster"
  type        = list(string)
  default     = []
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks that are allowed to access the cache cluster"
  type        = list(string)
  default     = []
}

variable "maintenance_window" {
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed"
  type        = string
  default     = "sun:05:00-sun:06:00"
}

variable "snapshot_retention_limit" {
  description = "The number of days for which ElastiCache will retain automatic cache cluster snapshots (Redis only)"
  type        = number
  default     = 7
}

variable "snapshot_window" {
  description = "The daily time range during which automated backups are created (Redis only)"
  type        = string
  default     = "03:00-04:00"
}

variable "automatic_failover_enabled" {
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails"
  type        = bool
  default     = false
}

variable "multi_az_enabled" {
  description = "Specifies whether to enable Multi-AZ Support for the cluster"
  type        = bool
  default     = false
}

variable "at_rest_encryption_enabled" {
  description = "Whether to enable encryption at rest"
  type        = bool
  default     = true
}

variable "transit_encryption_enabled" {
  description = "Whether to enable encryption in transit"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
