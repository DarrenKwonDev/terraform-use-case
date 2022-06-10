variable "bucket_name" {
  default = "terraform-static-deploy-bucket-wow"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    "Name" = var.bucket_name
  }
}
