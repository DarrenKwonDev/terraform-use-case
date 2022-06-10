# 참고로, iam은 region에 종속적이지 않은, global resource이다.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user

resource "aws_iam_user" "darren-kwon" {
  name = "darren_kwon"
  # password는 aws cli를 통해서 만들거나 aws_iam_user_login_profile를 활용할 것. 여기선 cli로 진행
  #  https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_account-policy.html
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy
resource "aws_iam_user_policy" "darren-kwon-policy" {
  name = "admin"
  user = aws_iam_user.darren-kwon.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["*"],
        Effect   = "Allow",
        Resource = ["*"]
      }
    ]
  })
}