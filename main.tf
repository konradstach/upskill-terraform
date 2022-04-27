resource "aws_s3_bucket" "tf-upskill-bucket" {
  bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.tf-upskill-bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.tf-upskill-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.tf-upskill-bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.tf-save-file-info.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_sns_topic" "tf-s3-event-notification-topic" {
  name = var.notification-topic

  policy = <<POLICY
{
    "Version":"2012-10-17",
    "Statement":[{
        "Effect": "Allow",
        "Principal": { "Service": "s3.amazonaws.com" },
        "Action": "SNS:Publish",
        "Resource": "arn:aws:sns:*:*:tf-s3-event-notification-topic",
        "Condition":{
            "ArnLike":{"aws:SourceArn":"${aws_s3_bucket.tf-upskill-bucket.arn}"}
        }
    }]
}
POLICY
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