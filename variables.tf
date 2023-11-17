# environment variables
variable "region" {
  description = "region to create resources"
  type        = string
}

variable "project_name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

#vpc variables 

# for vpc cidr block 
variable "vpc_cidr" {
    description    = "vpc cidr block"
    type           = string
}

#variable for the public subnet in AZ1
variable "public_subnet_az1_cidr" {
    description    = "public subnet az1 cidr block"
    type           = string
}

variable "public_subnet_az2_cidr" {
    description = "public subnet az2 cidr block"
    type        = string
}


#variable for the private app subnet in AZ1
variable "private_app_subnet_az1_cidr" {
    description    = "private app subnet az1 cidr block"
    type           = string
}

#variable for the private app subnet in AZ2
variable "private_app_subnet_az2_cidr" {
    description    = "private app subnet az2 cidr block"
    type           = string
}


#variable for the private data subnet in AZ1
variable "private_data_subnet_az1_cidr" {
    description    = "private data subnet az1 cidr block"
    type           = string
}

#variable for the private data subnet in AZ2
variable "private_data_subnet_az2_cidr" {
    description    = "private data subnet az2 cidr block"
    type           = string
}


# rds variables
variable "multi_az_deployment" {
    description = "create a standby db instance"
    type        = bool
}

variable "database_instance_identifier" {
    description    = "the database instance identifier"
    type           = string
}

variable "database_password" {
    description    = "the database password"
    type           = string
}

variable "database_instance_class" {
    description    = "the database instance type"
    type           = string
}

 variable "publicly_accessible" {
    description = "controls if instance is publicly accessible"
    type        = bool
}

# # acm variables
# variable "domain_name" {
#   description = "domain name"
#   type        = string
# }

# variable "alternative_names" {
#   description = "sub domain name"
#   type        = string
# }
