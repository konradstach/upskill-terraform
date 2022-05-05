data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "create-logs" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "s3-list" {
  statement {
    actions = [
      "s3:List*"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
    ]
  }
}

data "aws_iam_policy_document" "s3-get-object" {
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]
  }
}

data "aws_iam_policy_document" "s3-put-object" {
  statement {
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}/*",
    ]
  }
}

data "aws_iam_policy_document" "dynamodb-put-item" {
  statement {
    actions = [
      "dynamodb:PutItem",
    ]

    resources = [
      "arn:aws:dynamodb:${var.region}:${var.account_id}:table/${var.table_name}"
    ]
  }
}

data "aws_iam_policy_document" "sns-publish" {
  statement {
    actions = [
      "SNS:Publish",
    ]

    resources = [
      "arn:aws:sns:${var.region}:${var.account_id}:${var.notification-topic}"
    ]
  }
}

data "aws_iam_policy_document" "save-file-info" {
  source_policy_documents = [
    data.aws_iam_policy_document.dynamodb-put-item.json,
    data.aws_iam_policy_document.sns-publish.json,
    data.aws_iam_policy_document.create-logs.json
  ]
}

data "aws_iam_policy_document" "process-photo" {
  source_policy_documents = [
    data.aws_iam_policy_document.create-logs.json,
    data.aws_iam_policy_document.s3-put-object.json,
    data.aws_iam_policy_document.s3-get-object.json
  ]
}

