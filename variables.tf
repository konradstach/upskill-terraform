variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-1"
}

variable "s3_bucket_name" {
  default = "tf-upskill-bucket-0123"
}

variable "email_address" {
  default = "konrad.stach00@gmail.com"
}

variable "table_name" {
  default = "tf-photos-table"
}

variable "notification-topic" {
  default = "tf-s3-event-notification-topic"
}

variable "account_id"{
  default = 675328186963
}

variable "region"{
  default = "us-east-1"
}
