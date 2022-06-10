
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning
resource "aws_s3_bucket" "terraform_state" {
    bucket = "terraform-s3-backend-up-and-runnings"

    lifecycle {
        # s3가 지워지는 것을 방지. terraform destory를 통해 지우려고 하면 해당 명령어가 실패함. 진짜 지우려면 주석 달 것.
        prevent_destroy = true
    }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning
resource "aws_s3_bucket_versioning" "terraform-state-versioning" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration
# 서버측 암호화 활성화
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform-state-server-side-encryption-configuration" {
    bucket = aws_s3_bucket.terraform_state.id
    
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}
