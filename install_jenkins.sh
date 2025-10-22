#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
exec > /var/log/userdata.log 2>&1
set -x

sleep 10  # Wait for cloud-init networking to be ready
apt-get update -y
apt-get install -y openjdk-17-jdk
java -version

#install docker
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update -y
apt install -y docker-ce docker-ce-cli containerd.io
systemctl enable docker
systemctl start docker
docker --version

#install jenkins
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null
apt update -y
apt install -y jenkins
systemctl start jenkins
systemctl enable jenkins
