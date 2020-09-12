#!/bin/bash
sudo yum update -y
sudo curl -O https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
sudo unzip terraform_0.12.24_linux_amd64.zip
sudo cp terraform /usr/local/bin/ 
sudo cp terraform /usr/bin
sudo rm -f terraform_0.12.24_linux_amd64.zip
sudo wget https://releases.hashicorp.com/packer/1.5.6/packer_1.5.6_linux_amd64.zip
sudo unzip packer_1.5.6_linux_amd64.zip
sudo cp packer /usr/local/bin/ 
sudo cp packer /usr/sbin/
sudo echo 'export PATH=$PATH:/usr/local/bin/:/usr/sbin/' >> ~/.bashrc
sudo rm -f packer_1.5.6_linux_amd64.zip
sudo amazon-linux-extras install -y docker
sudo systemctl start docker
sudo usermod -aG docker ec2-user
sudo docker pull jenkins/jenkins
sudo docker run -d --name orionjenkins -p 8080:8080 -p 50000:50000 jenkins/jenkins
