# terraform examples

Terraform v1.1.9 on darwin_amd64

## terraform docs

[aws](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)  
[gcp](https://registry.terraform.io/providers/hashicorp/google/latest/docs)  
https://www.terraform.io/

## terraform feature

variables -> https://www.terraform.io/language/values/variables

- 선언 -> variables.tf
- variables.tf 에 선언한 변수에 변수 주입 -> terraform.tfvars

output -> https://www.terraform.io/language/values/outputs

- `terraform output [Name]`

data source -> https://www.terraform.io/language/data-sources

- terraform_remote_state -> https://www.terraform.io/language/state/remote-state-data
- 다른 폴더에 있는 \*.tf는 참조할 수 없기 때문에 output을 통해 .tfstate에 저장하여 활용해야 함. (https://blog.outsider.ne.kr/1303)

function -> https://www.terraform.io/language/functions

backend -> tfstate는 가급적 [remote backend](https://www.terraform.io/language/settings/backends/configuration)에 저장할 것

## tips

- 시크릿은 AWS 시크릿 매니저, kms, GCP google_secret_manager_secret 등을 data source로 통해서 가져와 사용 하는 것이 바람직하다.

## AWS

### s3 bucket policy

https://techblog.woowahan.com/6217/

### policy evaluation logic

https://docs.aws.amazon.com/ko_kr/IAM/latest/UserGuide/reference_policies_evaluation-logic.html

### s3 backend

[backend 동적 구성]
backend에는 변수나 참조를 사용할 수 없음. 그래서 작업마다 backend를 변경해야 한다면 hcl 파일을 별도로 생성한 다음 terraform init을 호출할 때   -backend-config 인수를 주어 변경시키는 방식으로 교체하는게 그나마 자동화된 방식임.  

아니면 그냥 terragrunt를 사용하는 것이 좋다. 이미 회사에서도 terragrunt 사용 중.  

[backend 생성]  
백엔드로 지정할 리소스가 기 존재해야만 하기 때문에 s3 backend 구동에는 순서를 지켜야 함.

1. s3와 dynamoDB를 우선 apply하여 생성해놓고  
2. 그 다음에 backend를 지정하여 다시 terraform init 후  apply  

[backend 삭제]

1. backend 설정을 제거하고, terraform init.  
2. 그 다음에 destroy 명령을 통해서 리소스를 삭제 함  

## ETC

### best practice

https://github.com/ozbillwang/terraform-best-practices
https://github.com/DevopsArtFactory/aws-provisioning
