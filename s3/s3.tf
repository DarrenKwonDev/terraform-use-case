# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "terrfaform-generated-bucket"

  tags = {
    "Name" = "terrfaform-generated-bucket"
  }
}