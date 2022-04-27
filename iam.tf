resource "aws_iam_role" "get-user-photos" {
  name = "get-user-photos"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  inline_policy {
    name = "get-user-photos-policy"
    policy = data.aws_iam_policy_document.s3-list.json
  }
}

resource "aws_iam_role" "save-file-info" {
  name = "save-file-info"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  inline_policy {
    name = "save-file-info-policy"
    policy = data.aws_iam_policy_document.save-file-info.json
  }
}

resource "aws_iam_role" "get-presigned-url" {
  name = "get-presigned-url"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  inline_policy {
    name = "get-presigned-url-policy"
    policy = data.aws_iam_policy_document.create-logs.json
  }
}

resource "aws_iam_role" "lambda-authorizer" {
  name = "lambda-authorizer"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  inline_policy {
    name = "lambda-authorizer-policy"
    policy = data.aws_iam_policy_document.create-logs.json
  }
}

resource "aws_iam_role" "process-photo" {
  name = "process-photo"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  inline_policy {
    name = "process-photo-policy"
    policy = data.aws_iam_policy_document.process-photo.json
  }
}


