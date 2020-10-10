## Provider
terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.5"
    }
  }
}

## Data
# AWS
data "aws_region" "current" {}

## Variables
# Naming
variable "Project_Prefix" {
  type        = string
  default     = "demo"
  description = "The prefix before all project created resources, including Transit Gateways, attachments and routing tables."
}

# HA/AZ Targetting
variable "AZ1" {
  type        = string
  default     = "a"
  description = "The Availability Zone character (e.g. eu-west-1a = a or eu-west-1b = b) for all assets targetting this AZ (one of each of the subnets, one for each of the firewalls, etc.)"
  validation {
    condition     = can(regex("^[a-z]$", var.AZ1))
    error_message = "Availability Zones are indicated by a single, lower case, letter."
  }
}

variable "AZ2" {
  type        = string
  default     = "b"
  description = "The Availability Zone character (e.g. eu-west-1a = a or eu-west-1b = b) for all assets targetting this AZ (one of each of the subnets, one for each of the firewalls, etc.)"
  validation {
    condition     = can(regex("^[a-z]$", var.AZ2))
    error_message = "Availability Zones are indicated by a single, lower case, letter."
  }
}