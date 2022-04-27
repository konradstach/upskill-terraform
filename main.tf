resource "aws_sns_topic" "tf-s3-event-notification-topic" {
  name = var.notification-topic
}

resource "aws_sns_topic_subscription" "email-target" {
  topic_arn = aws_sns_topic.tf-s3-event-notification-topic.arn
  protocol  = "email"
  endpoint  = var.email_address
}

resource "aws_dynamodb_table" "tf-photos-table" {
  name           = var.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "file_name"

  attribute {
    name = "file_name"
    type = "S"
  }
}