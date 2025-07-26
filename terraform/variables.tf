variable "ec2_key_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
}
