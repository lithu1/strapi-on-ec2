
output "public_ip" {
  value       = aws_instance.strapi_ec2.public_ip
  description = "Use this to access Strapi in browser: http://<public_ip>"
}




















