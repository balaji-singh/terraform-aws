variable "name" {
  description = "Name of the WAF Web ACL"
  type        = string
}

variable "description" {
  description = "Description of the WAF Web ACL"
  type        = string
  default     = "WAF Web ACL"
}

variable "scope" {
  description = "Scope of the WAF Web ACL. Valid values are REGIONAL or CLOUDFRONT"
  type        = string
  default     = "REGIONAL"
}

variable "enable_rate_limiting" {
  description = "Enable rate limiting rule"
  type        = bool
  default     = true
}

variable "rate_limit" {
  description = "The maximum number of requests from an IP address allowed in a 5-minute period"
  type        = number
  default     = 2000
}

variable "ip_rate_limit" {
  description = "Optional IP-based rate limit. Specify the maximum number of requests allowed from an IP in a 5-minute period"
  type        = number
  default     = null
}

variable "ip_blacklist" {
  description = "List of IP addresses to block"
  type        = list(string)
  default     = []
}

variable "enable_logging" {
  description = "Enable WAF logging"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain WAF logs"
  type        = number
  default     = 30
}

variable "redacted_fields" {
  description = "List of fields to redact from logs"
  type        = list(string)
  default     = ["authorization", "cookie"]
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "default_tags" {
  description = "A map of default tags to add to all resources"
  type        = map(string)
  default     = {}
}
