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