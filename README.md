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

10.	  Built a docker file used to create the docker image and pushed to the amazon ECR.

          ```Dockerfile
# Use the latest version of the Amazon Linux base image
FROM amazonlinux:2

# Update all installed packages to their latest versions
RUN yum update -y 

# Install the unzip package, which we will use it to extract the web files from the zip folder
RUN yum install unzip -y

# Install wget package, which we will use it to download files from the internet 
RUN yum install -y wget

# Install Apache
RUN yum install -y httpd

# Install PHP and various extensions
RUN amazon-linux-extras enable php7.4 && \
  yum clean metadata && \
  yum install -y \
    php \
    php-common \
    php-pear \
    php-cgi \
    php-curl \
    php-mbstring \
    php-gd \
    php-mysqlnd \
    php-gettext \
    php-json \
    php-xml \
    php-fpm \
    php-intl \
    php-zip

# Download the MySQL repository package
RUN wget https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm

# Import the GPG key for the MySQL repository
RUN rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022

# Install the MySQL repository package
RUN yum localinstall mysql80-community-release-el7-3.noarch.rpm -y

# Install the MySQL community server package
RUN yum install mysql-community-server -y

# Change directory to the html directory
WORKDIR /var/www/html

# Install Git
RUN yum install -y git

# Set the build argument directive
ARG PERSONAL_ACCESS_TOKEN
ARG GITHUB_USERNAME
ARG REPOSITORY_NAME
ARG WEB_FILE_ZIP
ARG WEB_FILE_UNZIP
ARG DOMAIN_NAME
ARG RDS_ENDPOINT
ARG RDS_DB_NAME
ARG RDS_MASTER_USERNAME
ARG RDS_DB_PASSWORD

# Use the build argument to set environment variables 
ENV PERSONAL_ACCESS_TOKEN=$PERSONAL_ACCESS_TOKEN
ENV GITHUB_USERNAME=$GITHUB_USERNAME
ENV REPOSITORY_NAME=$REPOSITORY_NAME
ENV WEB_FILE_ZIP=$WEB_FILE_ZIP
ENV WEB_FILE_UNZIP=$WEB_FILE_UNZIP
ENV DOMAIN_NAME=$DOMAIN_NAME
ENV RDS_ENDPOINT=$RDS_ENDPOINT
ENV RDS_DB_NAME=$RDS_DB_NAME
ENV RDS_MASTER_USERNAME=$RDS_MASTER_USERNAME
ENV RDS_DB_PASSWORD=$RDS_DB_PASSWORD

# Clone the GitHub repository
RUN git clone https://$PERSONAL_ACCESS_TOKEN@github.com/$GITHUB_USERNAME/$REPOSITORY_NAME.git

# Unzip the zip folder containing the web files
RUN unzip $REPOSITORY_NAME/$WEB_FILE_ZIP -d $REPOSITORY_NAME/

# Copy the web files into the HTML directory
RUN cp -av $REPOSITORY_NAME/$WEB_FILE_UNZIP/. /var/www/html

# Remove the repository we cloned
RUN rm -rf $REPOSITORY_NAME

# Enable the mod_rewrite setting in the httpd.conf file
RUN sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

# Give full access to the /var/www/html directory
RUN chmod -R 777 /var/www/html

# Give full access to the storage directory
RUN chmod -R 777 storage/

# Use the sed command to search the .env file for a line that starts with APP_ENV= and replace everything after the = character
RUN sed -i '/^APP_ENV=/ s/=.*$/=production/' .env

# Use the sed command to search the .env file for a line that starts with APP_URL= and replace everything after the = character
RUN sed -i "/^APP_URL=/ s/=.*$/=https:\/\/$DOMAIN_NAME\//" .env

# Use the sed command to search the .env file for a line that starts with DB_HOST= and replace everything after the = character
RUN sed -i "/^DB_HOST=/ s/=.*$/=$RDS_ENDPOINT/" .env

# Use the sed command to search the .env file for a line that starts with DB_DATABASE= and replace everything after the = character
RUN sed -i "/^DB_DATABASE=/ s/=.*$/=$RDS_DB_NAME/" .env 

# Use the sed command to search the .env file for a line that starts with DB_USERNAME= and replace everything after the = character
RUN  sed -i "/^DB_USERNAME=/ s/=.*$/=$RDS_MASTER_USERNAME/" .env

# Use the sed command to search the .env file for a line that starts with DB_PASSWORD= and replace everything after the = character
RUN  sed -i "/^DB_PASSWORD=/ s/=.*$/=$RDS_DB_PASSWORD/" .env

# Copy the file, AppServiceProvider.php from the host file system into the container at the path app/Providers/AppServiceProvider.php
COPY AppServiceProvider.php app/Providers/AppServiceProvider.php

# Expose the default Apache and MySQL ports
EXPOSE 80 3306

# Start Apache and MySQL
ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
```


## Conclusion
This project successfully deployed a dynamic e-commerce website application on AWS using Terraform, Docker, ECS, and ECR. The infrastructure setup ensures scalability, reliability, and security while following the best DevOps and cloud computing practices. Using version control, state management, and automated deployment processes enhances efficiency and facilitates collaboration among team members.
