# DevOps EC2 Setup with Terraform

## Prerequisites

- **Windows** machine  
- [Git](https://git-scm.com/)  
- [Terraform](https://developer.hashicorp.com/terraform/downloads) added to PATH  
- [AWS CLI](https://aws.amazon.com/cli/) installed and configured (`aws configure`)  
- An **EC2 key pair** (e.g., `devops-key`) either created in AWS or imported from the repo  

## Setup Instructions

1. Clone the repository:

```bash
git clone <repo-url>
cd <repo-folder>
```

2. Initialize Terraform:
terraform init
terraform plan
terraform apply

3. After apply completes, SSH into your instance:
ssh -i devops-key.pem ubuntu@<EC2-Public-IP>

4. Your instance will have Docker, Java, and Jenkins installed.

5. Access Jenkins via web browser:
URL: http://<EC2-Public-IP>:8080 
Admin password: sudo cat /var/lib/jenkins/secrets/initialAdminPassword

