terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9.0"
    }
}

  required_version = "~> 1.0"
}

provider "aws" {
  region = var.aws_region
}

esource "aws_s3_bucket" "tf-upskill-bucket" {
	bucket = "tf-upskill-bucket-0123"
}

resource "aws_s3_bucket_acl" "example" {
	bucket = aws_s3_bucket.tf-upskill-bucket.id
	acl = "private"
}

resource "aws_s3_bucket_public_access_block" "example" {
	bucket = aws_s3_bucket.tf-upskill-bucket.id

	block_public_acls = true
	block_public_policy = true
	ignore_public_acls = true
	restrict_public_buckets = true
}

resource "aws_iam_role" "iam_for_lambda" {
name = "iam_for_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
   	}
      }	
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = "${aws_iam_role.iam_for_lambda.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    },
    {
	"Effect": "Allow",
	"Action": [
	  "s3:*",
	  "s3-object-lambda:*"
	],
	"Resource":"*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "lambda:InvokeFunction"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:Describe*",
        "cloudwatch:Get*",
        "cloudwatch:List*"
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_lambda_function" "tf-get-user-photos" {
	filename = "zips/get-user-photos.jar"
	function_name = "tf-get-user-photos"
	role = aws_iam_role.iam_for_lambda.arn
	handler = "com.example.LambdaRequestHandler::handleRequest"

	source_code_hash = filebase64sha256("zips/get-user-photos.jar")
	runtime = "java11"
	timeout = 60
	memory_size = 512
}
