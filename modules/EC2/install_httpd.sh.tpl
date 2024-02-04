#!/bin/bash
sudo yum -y update
# Install Docker
sudo yum install -y docker

# Start and enable Docker service to run on boot
sudo systemctl start docker
sudo systemctl enable docker

# Add a user to the Docker group. Replace 'ec2-user' with your desired user.
# Note: You may need to log out and log back in for this to take effect.
sudo usermod -aG docker ec2-user

# Ensure the usermod command doesn't fail if 'ec2-user' doesn't exist
if id "ec2-user" &>/dev/null; then
   sudo usermod -aG docker ec2-user
else
    echo "User ec2-user not found, not adding to Docker group."
fi

aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 113222697619.dkr.ecr.us-east-1.amazonaws.com