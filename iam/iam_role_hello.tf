# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "hello" {
  name = "iam_role_hello"
  path = "/"

# EOF는 indent에 매우 민감하다. jsonencode 쓰는게 편함
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
            Action: "sts:AssumeRole"
            Sid: "",
            Effect: "Allow",
            Principal: {
                Service: "ec2.amazonaws.com"
            },
        }
    ]
  })
}

# policy -> user, group, role에 할당 가능한데, 테라폼에서는 각각 user_policy, group_policy, role_policy로 할당함.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
resource "aws_iam_role_policy" "hello_s3" {
  name = "iam_role_hello_s3"  
  role = aws_iam_role.hello.id
  policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
          {
              Action: "s3:GetObject",
              Sid: "AllowAppArtifactsReadAccess",
              Resource: "*",
              Effect: "Allow"
          }
      ]
  })
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
# aws_iam_instance_profile은 IAM 역할을 위한 컨테이너로서 인스턴스 시작 시 EC2 인스턴스에 역할 정보를 전달하는 데 사용
resource "aws_iam_instance_profile" "hello" {
  name = "hello-profile"
  role = aws_iam_role.hello.name
}