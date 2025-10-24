provider "aws" {
  region = "ap-south-1"  # Mumbai region
}

# Create a new key pair
resource "tls_private_key" "devops_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create AWS key pair using generated public key
resource "aws_key_pair" "devops_key" {
  key_name   = "devops-key"
  public_key = tls_private_key.devops_key.public_key_openssh
}

# Save private key to file so you can SSH
resource "local_file" "private_key" {
  content  = tls_private_key.devops_key.private_key_pem
  filename = "devops-key.pem"
}

# Create a new security group
resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH, HTTPS, and port 8080"
  vpc_id      = data.aws_vpc.default.id  # Make sure to define your VPC or use default

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Jenkins Web UI"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins-sg"
  }
}

# Optional: get default VPC if you want to attach SG to it
data "aws_vpc" "default" {
  default = true
}

# Get latest Ubuntu 22.04 LTS AMI (Linux/UNIX) for ap-south-1
data "aws_ami" "ubuntu_22_04" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# EC2 instance for Jenkins
resource "aws_instance" "jenkins_server" {
  ami                    = data.aws_ami.ubuntu_22_04.id
  instance_type          = "t2.large"
  key_name               = aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  user_data_replace_on_change = true

  user_data = file("install_jenkins.sh")

  tags = {
    Name = "DevOpsEc2MySQL"
  }
}

# Output EC2 public IP
output "ec2_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}
