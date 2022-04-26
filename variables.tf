variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}

variable "s3_bucket_name" {
  default = "tf-upskill-bucket-0123"
}
