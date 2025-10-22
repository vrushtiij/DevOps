provider "aws" {
  region = "ap-south-1"  # Mumbai region
}

# Use existing key pair
data "aws_key_pair" "devops_key" {
  key_name = "devops-key"
}

# Use existing security group
data "aws_security_group" "existing_sg" {
  filter {
    name   = "group-name"
    values = ["launch-wizard-2"]
  }
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
  instance_type          = "t2.micro"
  key_name               = data.aws_key_pair.devops_key.key_name
  vpc_security_group_ids = [data.aws_security_group.existing_sg.id]
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
