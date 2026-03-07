variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where EC2 will be created"
  type        = string
}

variable "list_of_open_ports" {
  description = "List of ports to open in Security Group"
  type        = list(number)
}