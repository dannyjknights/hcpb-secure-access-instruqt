variable "boundary_addr" {
  type = string
}

variable "auth_method_id" {
  type = string
}

variable "password_auth_method_login_name" {
  type = string
}

variable "password_auth_method_password" {
  type = string
}

variable "aws_access" {
  type = string
}

variable "aws_secret" {
  type = string
}

variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "private_vpc_cidr" {
  type        = string
  description = "The Private CIDR range to assign to the VPC"
}

variable "aws_vpc_cidr" {
  type        = string
  description = "The AWS Region CIDR range to assign to the VPC"
}

# variable "private_subnet_cidr" {
#   type        = string
#   description = "The Private CIDR range to assign to the Private subnet"
# }

variable "aws_subnet_cidr" {
  type = string
}

variable "aws_subnet_cidr2" {
  type = string
}

variable "availability_zone" {
  type        = string
  description = "EU West 2B within AWS to deploy the resources"
  default     = "eu-west-2b"
}

variable "availability_zone2" {
  type    = string
  default = "eu-west-2c"
}

variable "vault_addr" {
  type = string
}

variable "vault_token" {
  type = string
}

variable "boundary_vault_token" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_name" {
  type = string
}

variable "instances" {
  default = [
    "boundary-1-dev",
    # "boundary-2-dev",
    # "boundary-3-production",
    # "boundary-4-production"
  ]
}

variable "vm_tags" {
  default = [
    { "Name" : "boundary-1-dev", "service-type" : "database", "application" : "dev" },
    # { "Name" : "boundary-2-dev", "service-type" : "database", "application" : "dev" },
    # { "Name" : "boundary-3-production", "service-type" : "database", "application" : "production" },
    # { "Name" : "boundary-4-production", "service-type" : "database", "application" : "production" }
  ]
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "s3_bucket_name_tags" {
  type        = string
  description = "Name tag to associate to the S3 Bucket"
}

variable "s3_bucket_env_tags" {
  type        = string
  description = "Environment tag to associate to the S3 Bucket"
}