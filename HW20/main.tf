terraform {
  backend "s3" {
    bucket = "terraform-state-danit-devops-klimchuk"
    key    = "vasya-klimchuk/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
}

data "aws_vpc" "selected" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

module "web_server_nginx" {
  source             = "./modules/web_server"
  vpc_id             = data.aws_vpc.selected.id
  subnet_id          = data.aws_subnets.all.ids[0]
  list_of_open_ports = [22, 80, 443]
}

output "nginx_ip" {
  value = module.web_server_nginx.instance_public_ip
}