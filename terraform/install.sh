#!/bin/bash
set -e

# Update the system
sudo apt update -y
sudo apt upgrade -y

# Install Java (OpenJDK 21)
sudo apt install -y openjdk-21-jdk openjdk-21-jre

# Add Jenkins repository
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update -y
sudo apt install -y jenkins

# Start Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Install Docker
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg lsb-release unzip
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose

# Install Nginx
sudo apt update -y
sudo apt install -y nginx

# Start Nginx service
sudo systemctl start nginx
sudo systemctl enable nginx

# # Download SonarQube Scanner
# wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip

# # Unzip the Scanner
# unzip sonar-scanner-cli-4.7.0.2747-linux.zip

# # Move the Scanner to a directory in your PATH
# sudo mv sonar-scanner-4.7.0.2747-linux /opt/sonar-scanner
# sudo ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner

# Add users to Docker group
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Ensure groups are applied
newgrp docker <<EOF
    # Clone the repository and start the Docker Compose application
    cd /home/ubuntu
    git clone https://github.com/faisalmalik47/ScoreMe-Assessment.git
    cd ScoreMe-Assessment
    docker-compose up -d
EOF
