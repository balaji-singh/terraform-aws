output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  value       = var.create_dynamodb_lock_table ? aws_dynamodb_table.lock[0].name : ""
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table for state locking"
  value       = var.create_dynamodb_lock_table ? aws_dynamodb_table.lock[0].arn : ""
}
