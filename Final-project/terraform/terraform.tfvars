# AWS account config
region = "us-east-1"

# General for all infrastructure
name = "vasylkly"

vpc_id = "vpc-01a469e2b99593f7d"
subnets_ids = [
  "subnet-038d2932ebed5a6a1",
  "subnet-08905df55efd651c4",
  "subnet-0523fcb76098e3015",
  "subnet-0eb2a9c7c11c40a1e",
  "subnet-05b0b22cefe74f51e"
]

tags = {
  Environment = "test"
  TfControl   = "true"
}

zone_name = "devops12.test-danit.com"