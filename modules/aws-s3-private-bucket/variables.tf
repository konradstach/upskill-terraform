variable "s3_bucket_name" {
  default = "tf-upskill-bucket-0123"
}

variable "s3_bucket_notification_lambda_arn" {
  type = string
}

variable "s3_bucket_notification_events" {
  type = list(string)
}

