variable "aws_region" {
  type=string
  default="ap-northeast-2"
  description = "region for aws"
}

variable "iam_user_list" {
  type=list(string)
}