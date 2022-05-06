# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "main" {
  bucket = "devopsart-terraform-101"

  tags = {
    Name = "devopsart-terraform-101"
  }
}
