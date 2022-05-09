output "bucket_arn" {
  description = "ARN of the bucket"
  value       = aws_s3_bucket.s3-bucket.arn
}

output "bucket_id" {
  description = "Id of the bucket"
  value       = aws_s3_bucket.s3-bucket.id
}