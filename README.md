# Rentzone - Dynamic E-commerce Website Deployment on AWS with Terraform, Docker, ECS, and ECR

This project aims to deploy a dynamic e-commerce website application on AWS using Terraform, Docker, Amazon ECS, and ECR. The deployment incorporates best practices for infrastructure management, version control, and security. Below is an overview of the setup and deployment process.

## Setup Process

1. **GitHub Repository Setup**
   - Created a GitHub repository to store Terraform infrastructure configurations.
   - Cloned the repository to the local desktop to manage changes locally.
   - Pushed changes from the local repository to the remote repository to maintain version history and collaboration.

2. **IAM User Creation**
   - Created an IAM user named Terraform-user with programmatic access.
   - Attached the AdministratorAccess permission policy to the Terraform-user to enable the user to create AWS resources.

3. **AWS Profile Configuration**
   - Configured a named profile (terraform-user) for the IAM user to allow Terraform to authenticate with AWS using the user's credentials.

4. **Terraform State Management**
   - Created an S3 bucket named `chidex-terraform-remote-state1` to store the Terraform state file (`terraform.tfstate`).
   - Utilized DynamoDB to lock the Terraform state file, preventing concurrent modifications.

5. **Variable Management**
   - Created a `tfvars` file to externalize variable definitions and facilitate easier management of a large number of variables.

6. **AWS Resource Provisioning**
   - Utilized Terraform to provision AWS resources, including:
     - Virtual Private Cloud (VPC) with public and private subnets across multiple availability zones.
     - Internet Gateway for connectivity between VPC instances and the Internet.
     - Security Groups for network firewall rules.
     - Task execution role in ECS for container management.
     - Amazon ECS for deploying, managing, and scaling the application in containers.
     - Application Load Balancer (ALB) and target groups for distributing web traffic.
     - Auto Scaling Group (ASG) to manage EC2 instances for website availability and scalability.
     - Certificate Manager for securing application communication.
     - Simple Notification Service (SNS) for alerting activities within the Auto Scaling Group.
     - Registered domain name and set up DNS records using Route 53.

7. **Version Control and Collaboration**
   - Stored web files on GitHub for version control and collaboration among team members.

8. **AWS S3 Bucket for Environment Files**
   - Created an S3 bucket (`chidex-ecs-tf-env-rentzone-file`) to store environment files from the local computer.

9. **AWS Provider Configuration**
   - Configured the AWS provider file (`provider.tf`) to establish a secure connection between Terraform and AWS.

## Conclusion
This project successfully deployed a dynamic e-commerce website application on AWS using Terraform, Docker, ECS, and ECR. The infrastructure setup ensures scalability, reliability, and security while following the best DevOps and cloud computing practices. Using version control, state management, and automated deployment processes enhances efficiency and facilitates collaboration among team members.
