terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
#provider block 
provider "aws" {
  region     = "eu-north-1"
  access_key = "XXXXXXxxxxxxxxxx"
  secret_key = "XXXXXXXXXXXXXXXXXXXXX"

  
}

#Security Group Block
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow inbound traffic on port 80"

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 5001
    to_port     = 5001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
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
    from_port   = 22
    to_port     = 22
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



#Resource Block
resource "aws_instance" "demo1" {
  ami           = "ami-08eb150f611ca277f" #ubuntu
  instance_type = "t3.large"
  # secutrity  group Attach
  vpc_security_group_ids = [aws_security_group.allow_http.id]
  key_name               = "KEY pair"
  user_data = file("${path.module}/userdata.sh")
  root_block_device {
    volume_size = 20  # Increase this size (in GB)
  }


  tags = {
    Name = "Mern_web_deploy"
  }
}

#Output Ip Block
output "ip" {
  value = "DEMO1  IP: ${aws_instance.demo1.public_ip}"

}

