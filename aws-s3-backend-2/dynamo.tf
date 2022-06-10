
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table
resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform_locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key     = "LockID" # 파티션 키. 문서에 따르면 locking용으로 사용한다면 반드시 파티션 키의 이름이 LockID여야만 함

    # Only required for hash_key and range_key attributes. 
    # hash_key에 대한 name, type을 지정
    attribute {
        name = "LockID"
        type = "S" # S, N, or B for (S)tring, (N)umber or (B)inary data
    }
}