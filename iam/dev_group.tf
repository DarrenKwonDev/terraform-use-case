# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group
resource "aws_iam_group" "dev_group" {
  name = "dev_group"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership
resource "aws_iam_group_membership" "dev_membership" {
  # 이름은 마음대로 지어도 되긴 하는데 여기선 편의성을 위해 group_name을 그대로 사용
  name = aws_iam_group.dev_group.name

  # 추가할 유저
  users = [ 
      aws_iam_user.darren-kwon.name
  ]

  group = aws_iam_group.dev_group.name
}


