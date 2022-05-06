module "tf-upskill-bucket" {
  source = "./modules/aws-s3-private-bucket"

  s3_bucket_name = "tf-upskill-bucket-0123"
  s3_bucket_notification_lambda_arn = module.tf-save-file-info.lambda_arn
  s3_bucket_notification_events = ["s3:ObjectCreated:*"]
}
