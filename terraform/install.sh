#!/bin/bash
set -e

# Update the system
sudo apt update -y
sudo apt upgrade -y

# Install Java (OpenJDK 11)
sudo apt install -y openjdk-17-jdk 
sudo apt install default-jre -y

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

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

# Install Docker
sudo apt update -y
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose

# Download SonarQube Scanner
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.7.0.2747-linux.zip

# Unzip the Scanner
unzip sonar-scanner-cli-4.7.0.2747-linux.zip

# Move the Scanner to a directory in your PATH
sudo mv sonar-scanner-4.7.0.2747-linux /opt/sonar-scanner
sudo ln -s /opt/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner


# Add user to Docker group
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins
newgrp docker


# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Clone the repository and start the Docker Compose application
sudo -u ubuntu bash -c "
cd /home/ubuntu
git clone https://github.com/faisalmalik47/ScoreMe-Assessment.git
cd ScoreMe-Assessment
docker-compose up -d
"
