provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "tfstate-s3" {
  bucket = "my-tfstate-bucket-as-a-backend"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning
resource "aws_s3_bucket_versioning" "tfstate-s3-versioning" {
  bucket = aws_s3_bucket.tfstate-s3.id
  versioning_configuration {
    status = "Enabled"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "tfstate_state_lock" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID" # 파티션 키

  # Only required for hash_key and range_key attributes. 
  # hash_key에 대한 name, type을 지정
  attribute {
    name = "LockID"
    type = "S" # S, N, or B for (S)tring, (N)umber or (B)inary data
  }

  tags = {
    Name = "terraform-lock"
  }
}