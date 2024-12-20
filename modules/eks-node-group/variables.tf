# ---------------------------------------------------------------------------------------------------------------------
# Required Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role for the EKS node group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS node group"
  type        = list(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# Scaling Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

# ---------------------------------------------------------------------------------------------------------------------
# Node Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "ami_type" {
  description = "Type of Amazon Machine Image (AMI) associated with the EKS Node Group"
  type        = string
  default     = "AL2_x86_64"
}

variable "instance_types" {
  description = "List of instance types associated with the EKS Node Group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 20
}

variable "ami_release_version" {
  description = "AMI version of the EKS Node Group"
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------------------------------------------------
# Remote Access Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "ec2_ssh_key" {
  description = "EC2 Key Pair name that provides access for SSH communication with the worker nodes"
  type        = string
  default     = null
}

variable "source_security_group_ids" {
  description = "Set of EC2 Security Group IDs to allow SSH access from on the worker nodes"
  type        = list(string)
  default     = []
}

# ---------------------------------------------------------------------------------------------------------------------
# Node Labels and Taints
# ---------------------------------------------------------------------------------------------------------------------

variable "node_labels" {
  description = "Key-value mapping of Kubernetes labels for EKS managed node groups"
  type        = map(string)
  default     = {}
}

variable "taint_key" {
  description = "Key for the taint"
  type        = string
  default     = ""
}

variable "taint_value" {
  description = "Value for the taint"
  type        = string
  default     = ""
}

variable "taint_effect" {
  description = "Effect for the taint"
  type        = string
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# Launch Template Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "launch_template_name" {
  description = "Name of the launch template"
  type        = string
  default     = null
}

variable "launch_template_version" {
  description = "Version of the launch template"
  type        = string
  default     = null
}

# ---------------------------------------------------------------------------------------------------------------------
# Update Configuration
# ---------------------------------------------------------------------------------------------------------------------

variable "max_unavailable" {
  description = "Maximum number of nodes unavailable at once during a version update"
  type        = number
  default     = 1
}

# ---------------------------------------------------------------------------------------------------------------------
# Optional Variables
# ---------------------------------------------------------------------------------------------------------------------

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "module_depends_on" {
  description = "List of modules or resources this module depends on"
  type        = list(any)
  default     = []
}
