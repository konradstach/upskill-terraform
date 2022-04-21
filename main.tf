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

resource "aws_apigatewayv2_api" "tf-upskill-api" {
  name          = "tf-upskill-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "tf-upskill-api-stage" {
  api_id = aws_apigatewayv2_api.tf-upskill-api.id
  name   = "upskill-api-stage"
  auto_deploy = "true"
}

resource "aws_apigatewayv2_integration" "tf-get-presigned-url" {
  api_id = aws_apigatewayv2_api.tf-upskill-api.id

  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.tf-get-presigned-url.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "tf-get-presigned-url" {
  api_id = aws_apigatewayv2_api.tf-upskill-api.id

  route_key = "GET /presigned-url"
  target    = "integrations/${aws_apigatewayv2_integration.tf-get-presigned-url.id}"
}

resource "aws_lambda_permission" "tf-presigned-url" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf-get-presigned-url.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.tf-upskill-api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_integration" "tf-get-photos" {
  api_id = aws_apigatewayv2_api.tf-upskill-api.id

  integration_type = "AWS_PROXY"
  integration_uri = aws_lambda_function.tf-get-user-photos.invoke_arn
  integration_method = "POST"
  payload_format_version = "2.0" 
}

resource "aws_apigatewayv2_route" "tf-get-photos" {
  api_id = aws_apigatewayv2_api.tf-upskill-api.id

  route_key = "GET /photos"
  target    = "integrations/${aws_apigatewayv2_integration.tf-get-photos.id}"
}

resource "aws_lambda_permission" "tf-get-user-photos" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf-get-user-photos.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.tf-upskill-api.execution_arn}/*/*"
}

resource "aws_s3_bucket" "tf-upskill-bucket" {
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
    },
    {
      "Effect": "Allow",
      "Action": [
	"dynamodb:PutItem"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
	"SNS:Publish"
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

resource "aws_lambda_function" "tf-save-file-info" {
	filename = "zips/save-file-info.jar"
	function_name = "tf-save-file-info"
	role = aws_iam_role.iam_for_lambda.arn
	handler = "com.example.SaveFileInfoHandler::handleRequest"
	
	source_code_hash = filebase64sha256("zips/save-file-info.jar")
	runtime = "java11"
	timeout = 120
	memory_size = 512
}

resource "aws_lambda_function" "tf-get-presigned-url" {
	filename = "zips/get-presigned-url.jar"
	function_name = "tf-get-presigned-url"
	role = aws_iam_role.iam_for_lambda.arn
	handler = "com.example.LambdaRequestHandler::handleRequest"
	
	source_code_hash = filebase64sha256("zips/get-presigned-url.jar")
	runtime = "java11"
	timeout = 30
	memory_size = 512
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.tf-save-file-info.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.tf-upskill-bucket.arn
}

resource "aws_sns_topic" "tf-s3-event-notification-topic" {
  name = "tf-s3-event-notification-topic"

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
  endpoint  = "konrad.stach00@gmail.com"
}

resource "aws_dynamodb_table" "tf-photos-table" {
  name           = "tf-photos-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "file_name"

  attribute {
    name = "file_name"
    type = "S"
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.tf-upskill-bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.tf-save-file-info.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
