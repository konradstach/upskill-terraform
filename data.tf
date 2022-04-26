data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "example" {
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

  statement {
    actions = [
      "s3:*",
      "s3-object-lambda:*"
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "lambda:InvokeFunction"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "dynamodb:PutItem"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "SNS:Publish"
    ]

    resources = [
      "*"
    ]
  }
}