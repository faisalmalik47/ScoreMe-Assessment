provider "aws" {
  region = "ap-south-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group for Jenkins
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins_sg"
  description = "Security group for Jenkins server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_sg"
  }
}

# IAM Role for SSM
resource "aws_iam_role" "ssm_role" {
  name = "ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Attach AmazonSSMManagedInstanceCore policy to the IAM role
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile for EC2
resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm-instance-profile-new"
  role = aws_iam_role.ssm_role.name
}

# EC2 Instance with IAM Role
resource "aws_instance" "jenkins" {
  ami           = "ami-0c2af51e265bd5e0e"  # Ubuntu 22.04 AMI ID for ap-south-1
  instance_type = "t2.medium"               # Instance Type
  key_name      = "demo"                   # SSH key pair

  user_data = file("install.sh") # Use the install.sh script as user_data

  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]  # Attach the security group

  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name  # Attach IAM role

  tags = {
    Name = "JenkinsServer"
  }
}

# Create an EBS volume
resource "aws_ebs_volume" "jenkins_volume" {
  availability_zone = aws_instance.jenkins.availability_zone
  size              = 30 # Size in GB

  tags = {
    Name = "JenkinsVolume"
  }
}

# Attach the EBS volume to the EC2 instance
resource "aws_volume_attachment" "jenkins_volume_attachment" {
  device_name = "/dev/sdh"  # Device name to attach as in the instance
  volume_id   = aws_ebs_volume.jenkins_volume.id
  instance_id = aws_instance.jenkins.id
}
  
# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.jenkins.public_ip
}
