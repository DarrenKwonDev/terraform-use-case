# 참고로, iam은 region에 종속적이지 않은, global resource이다.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user

variable "user_darren_kwon_name" {
  default = "darren_kwon"
}

resource "aws_iam_user" "darren-kwon" {
  name = var.user_darren_kwon_name
  # password는 aws cli를 통해서 만들거나 aws_iam_user_login_profile를 활용할 것. 여기선 cli로 진행
  #  https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_account-policy.html
}