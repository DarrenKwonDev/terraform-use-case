variable "project" { 
    description = "create terraform.tfvars and define this variable"
}

variable "credentials_file" {
    default = "gcp-study-358716-fc84c4978442.json"
}

variable "region" {
  default = "asia-northeast3"
}

variable "zone" {
  default = "asia-northeast3-a"
}
