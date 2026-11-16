output "state_bucket_name" {
  description = "S3 bucket name to use in the root project's S3 backend configuration."
  value       = aws_s3_bucket.state.bucket
}

output "lock_table_name" {
  description = "DynamoDB table name to use for Terraform state locking."
  value       = aws_dynamodb_table.locks.name
}

output "aws_region" {
  value = var.aws_region
}
