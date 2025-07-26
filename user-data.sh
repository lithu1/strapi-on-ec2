
#!/bin/bash
apt update -y
apt install -y docker.io
systemctl start docker
systemctl enable docker
usermod -aG docker ubuntu
docker pull lithu213/strapi-app:latest
docker run -d -p 80:1337 --name strapi-app lithu213/strapi-app:latest









