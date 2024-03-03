#!/bin/bash
 
# Installations:

## Docker
sudo yum update -y
sudo amazon-linux-extras install docker
sudo yum install -y docker
sudo service docker start
sudo chkconfig docker on
sudo usermod -aG docker ec2-user

## Docker-Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc

## GIT
sudo yum update -y
sudo yum install -y git
git version

## Clone Git-Repo
git clone https://github.com/Parshant-Jagwani/Monitoring-Stack.git

ls -a ./Monitoring-Stack

#### OUT-PUT
sudo docker version
sudo docker-compose --version
git version
sudo docker ps
ls -a ./Monitoring-Stack