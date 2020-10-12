## Variables
# Naming
variable "VPC_Suffix" {
  type        = string
  default     = "sechub"
  description = "The string to add to the name of the VPC after the project prefix and a hyphen (e.g. 'demo-sechub')"
}
# IAM Roles/Profiles
variable "IAM_Role_VPC_Flow_Logs_ARN" {
  type        = string
  default     = null
  description = "The ARN of the IAM role which has been created to work with VPC Flow Logs."
  validation {
    condition     = var.IAM_Role_VPC_Flow_Logs_ARN == null || can(regex("^arn:aws:iam::[0-9]+:role\\/.*", var.IAM_Role_VPC_Flow_Logs_ARN))
    error_message = "ARNs must match a specific template."
  }
}
# IP Addressing
variable "VPC_CIDR" {
  type        = string
  default     = "192.0.2.0/24"
  description = "The CIDR for the VPC which must be large enough to support 4 subnets."
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\/(1[6-9]|2[0-8])$", var.VPC_CIDR))
    error_message = "Must be a valid IPv4 CIDR with a CIDR Mask between 16 and 28 bits (/16-/28)."
  }
}
# Options
variable "Enable_VPC_Flow_Logs" {
  type        = bool
  default     = false
  description = "Explicitly enable this to permit VPC flow logs to be created."
}

## Resources
# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.VPC_CIDR
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.Project_Prefix}-${var.VPC_Suffix}"
  }
}
# VPC Flow Logs
resource "aws_cloudwatch_log_group" "VPC_Flow_Logs" {
  count = var.Enable_VPC_Flow_Logs ? 1 : 0
  name  = "Flow_Logs-${aws_vpc.vpc.tags.Name}"
}
resource "aws_flow_log" "VPC_Flow_Logs" {
  count           = var.Enable_VPC_Flow_Logs ? 1 : 0
  iam_role_arn    = var.IAM_Role_VPC_Flow_Logs_ARN
  log_destination = aws_cloudwatch_log_group.VPC_Flow_Logs[0].arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
}

## Output
output "aws_vpc_vpc" {
  value = aws_vpc.vpc
}
output "aws_vpc_vpc_id" {
  value = aws_vpc.vpc.id
}