##################################################
# AWS

variable "aws_region" {
  description = "AWS Region"
  type        = string
}

##################################################
# PROJECT

variable "project_name" {
  description = "Project Name"
  type        = string
}

##################################################
# S3 WEBSITE

variable "website_bucket_name" {
  description = "S3 Bucket Name"

  type = string
}

##################################################
# DYNAMODB

variable "dynamodb_table_name" {
  description = "Trade Table Name"

  type = string
}

##################################################
# COGNITO

variable "cognito_user_pool_name" {
  description = "User Pool Name"

  type = string
}

variable "cognito_client_name" {
  description = "User Pool Client Name"

  type = string
}

##################################################
# TAGS

variable "environment" {
  description = "Environment"

  type = string
}

variable "owner" {
  description = "Project Owner"

  type = string
}

