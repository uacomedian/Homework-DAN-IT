terraform {
  backend "s3" {
    bucket         = "vasylkly-tf-state"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "vasylkly-tf-lock"
  }
}


