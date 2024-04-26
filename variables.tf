variable "boundary_addr" {
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

variable "aws_vpc_cidr" {
  type        = string
  description = "The AWS Region CIDR range to assign to the VPC"
  default     = "172.31.0.0/16"
}

variable "aws_subnet_cidr" {
  type    = string
  default = "172.31.32.0/24"
}

variable "aws_subnet_cidr2" {
  type    = string
  default = "172.31.33.0/24"
}

variable "availability_zone" {
  type    = string
  default = "eu-west-2b"
}

variable "availability_zone2" {
  description = "Second AZ for RDS deployment"
  type        = string
  default     = "eu-west-2c"
}

variable "vault_addr" {
  type = string
}

variable "vault_token" {
  type = string
}

variable "db_username" {
  type    = string
  default = "dbadmin"
}

variable "db_password" {
  type = string
}

variable "db_name" {
  type    = string
  default = "boundarydemo"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "s3_bucket_name_tags" {
  type        = string
  description = "Name tag to associate to the S3 Bucket"
  default     = "session-recording"
}

variable "s3_bucket_env_tags" {
  type        = string
  description = "Environment tag to associate to the S3 Bucket"
  default     = "boundary"
}

variable "rdp_admin_pass" {
  type        = string
  description = "The password to set on the windows target for the admin user"
}

variable "rdp_admin_username" {
  type        = string
  description = "The admin username for RDP target"
  default     = "Administrator"
}