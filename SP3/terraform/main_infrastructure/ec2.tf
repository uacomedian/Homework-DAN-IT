resource "aws_key_pair" "deployer" {
  key_name   = "danit-sp3-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3zIVg1/odrk5uzyBizUNpvT4+e2rWrjqf4GzqSTQ+W vasyl-sp3-project"
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH, HTTP and Jenkins traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins_master" {
  ami                    = "ami-0084a47cc718c111a"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "${aws_key_pair.deployer.public_key}" >> /home/ubuntu/.ssh/authorized_keys
              EOF

  tags = {
    Name = "Jenkins-Master"
  }
}

resource "aws_spot_instance_request" "jenkins_worker" {
  ami                    = "ami-0084a47cc718c111a"
  instance_type          = "t3.micro"
  spot_price             = "0.01"
  wait_for_fulfillment   = true
  
  # Правильний аргумент для Spot-інстансів:
  instance_interruption_behavior = "terminate"
  
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  user_data = <<-EOF
              #!/bin/bash
              echo "${aws_key_pair.deployer.public_key}" >> /home/ubuntu/.ssh/authorized_keys
              EOF

  tags = {
    Name = "Jenkins-Worker"
  }
}

output "jenkins_master_public_ip" {
  value = aws_instance.jenkins_master.public_ip
}

output "jenkins_worker_private_ip" {
  value = aws_spot_instance_request.jenkins_worker.private_ip
}