  provider "aws" {
  region = "us-east-2"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg-${random_id.suffix.hex}"
  description = "Allow HTTP and SSH"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "strapi_ec2" {
  ami                         = "ami-0c55b159cbfafe1f0" # Ubuntu 22.04 LTS in us-east-2
  instance_type               = "t2.micro"
  key_name                    = "hello" # Your existing key pair 
  vpc_security_group_ids      = [aws_security_group.strapi_sg.id]
  user_data                   = file("${path.module}/user-data.sh")

  tags = {
    Name = "strapi-instance-${random_id.suffix.hex}"
  }
}









