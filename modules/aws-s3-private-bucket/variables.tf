variable "s3_bucket_name" {
  type = string
}

variable "s3_bucket_notification_lambda_arn" {
  type = string
}

variable "s3_bucket_notification_events" {
  type = list(string)
}

