# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group for HTTP, Strapi (1337), SSH
resource "aws_security_group" "strapi_sg" {
  name        = "strapi-security-group"
  description = "Allow HTTP, Strapi port, and SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP (80)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Strapi (1337)"
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH (22)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance to host Strapi
resource "aws_instance" "strapi" {
  ami                    = "ami-05fb0b8c1424f266b"  # Ubuntu 22.04 LTS in us-east-2
  instance_type          = "t2.micro"
  key_name               = var.ec2_key_name
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update && apt install -y docker.io
              systemctl enable docker
              systemctl start docker
              docker pull lithu213/strapi-ec2:${var.image_tag}
              docker run -d --name strapi -p 1337:1337 lithu213/strapi-ec2:${var.image_tag}
              EOF

  tags = {
    Name = "strapi-ec2"
  }
}
