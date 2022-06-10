# 불편한 것이, 변수나 참조를 사용할 수 없음.  
# 그러니까 terragrunt 사용하셈
terraform {
    backend "s3" {
        bucket = "terraform-s3-backend-up-and-runnings"
        key    = "mycusompath/terraform.tfstate"
        region = "us-east-2"
        encrypt = true
        dynamodb_table = "terraform_locks"
    }
}

provider "aws" {
    region = "us-east-2"
}

