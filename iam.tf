resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  inline_policy {
    name = "lambda_policy"
    policy = data.aws_iam_policy_document.example.json
  }
}
