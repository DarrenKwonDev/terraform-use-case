terraform {
  # https://www.terraform.io/language/settings/backends/s3
  backend "s3" {                                                 
    bucket         = "my-tfstate-bucket-as-a-backend"                      
    key            = "terraform/terraform.tfstate" # s3 내에서 tfstate 저장 경로
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}