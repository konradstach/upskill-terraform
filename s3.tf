module "tf-upskill-bucket" {
  source = "./modules/aws-s3-private-bucket"

  s3_bucket_name = "tf-upskill-bucket-0123"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.tf-upskill-bucket.bucket_id

  lambda_function {
    lambda_function_arn = module.tf-save-file-info.lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

#  depends_on = [aws_lambda_permission.allow_bucket]
}

#resource "aws_s3_bucket_notification" "bucket_notification" {
#  bucket = module.tf-upskill-bucket.bucket_id
#
#  lambda_function {
#    lambda_function_arn = module.tf-save-file-info.lambda_arn
#    events              = ["s3:ObjectCreated:*"]
#  }
#
#  depends_on = [module.tf-save-file-info]
#}