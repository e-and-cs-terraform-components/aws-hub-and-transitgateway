## Variables
# Naming
variable "Inspect_Suffix" {
  type        = string
  default     = "inspect"
  description = "The string to add to the name of the Inspect Subnets after the project prefix and a hyphen, but before the AZ (e.g. 'demo-inspect_aza')"
}
variable "Int_Transit_Suffix" {
  type        = string
  default     = "int_transit"
  description = "The string to add to the name of the Internal Transit Subnets after the project prefix and a hyphen, but before the AZ (e.g. 'demo-int_transit_aza')"
}
# IP Addressing
variable "Subnet_Inspect_AZ1_CIDR" {
  type        = string
  default     = "192.0.2.0/28"
  description = "The CIDR for the 'Inspect' subnet in AZ1."
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\/(1[6-9]|2[0-8])$", var.Subnet_Inspect_AZ1_CIDR))
    error_message = "Must be a valid IPv4 CIDR with a CIDR Mask between 16 and 28 bits (/16-/28)."
  }
}
variable "Subnet_Inspect_AZ2_CIDR" {
  type        = string
  default     = "192.0.2.16/28"
  description = "The CIDR for the 'Inspect' subnet in AZ2."
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\/(1[6-9]|2[0-8])$", var.Subnet_Inspect_AZ2_CIDR))
    error_message = "Must be a valid IPv4 CIDR with a CIDR Mask between 16 and 28 bits (/16-/28)."
  }
}
variable "Subnet_Internal_Transit_AZ1_CIDR" {
  type        = string
  default     = "192.0.2.32/28"
  description = "The CIDR for the 'Transit' subnet in AZ1."
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\/(1[6-9]|2[0-8])$", var.Subnet_Internal_Transit_AZ1_CIDR))
    error_message = "Must be a valid IPv4 CIDR with a CIDR Mask between 16 and 28 bits (/16-/28)."
  }
}
variable "Subnet_Internal_Transit_AZ2_CIDR" {
  type        = string
  default     = "192.0.2.48/28"
  description = "The CIDR for the 'Transit' subnet in AZ2."
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[0-9][0-9]|[0-9])\\/(1[6-9]|2[0-8])$", var.Subnet_Internal_Transit_AZ2_CIDR))
    error_message = "Must be a valid IPv4 CIDR with a CIDR Mask between 16 and 28 bits (/16-/28)."
  }
}
# Options
variable "South_North_Gateway_ENI" {
  type        = string
  default     = null
  description = "The ENI used to route traffic from South (protected spokes) to North (the Internet)."
  validation {
    condition     = var.South_North_Gateway_ENI == null || can(regex("^eni-[0-9a-f]+$", var.South_North_Gateway_ENI))
    error_message = "Resources must be named in a particular style."
  }
}

## Resources
#  Subnets
resource "aws_subnet" "inspect_az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Subnet_Inspect_AZ1_CIDR
  availability_zone = "${data.aws_region.current.name}${var.AZ1}"

  tags = {
    Name = "${aws_vpc.vpc.tags.Name}-${var.Inspect_Suffix}-az${var.AZ1}"
  }
}

resource "aws_subnet" "inspect_az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Subnet_Inspect_AZ2_CIDR
  availability_zone = "${data.aws_region.current.name}${var.AZ2}"

  tags = {
    Name = "${aws_vpc.vpc.tags.Name}-${var.Inspect_Suffix}-az${var.AZ2}"
  }
}

resource "aws_subnet" "int_transit_az1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Subnet_Internal_Transit_AZ1_CIDR
  availability_zone = "${data.aws_region.current.name}${var.AZ1}"

  tags = {
    Name = "${aws_vpc.vpc.tags.Name}-${var.Int_Transit_Suffix}-az${var.AZ1}"
  }
}

resource "aws_subnet" "int_transit_az2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.Subnet_Internal_Transit_AZ2_CIDR
  availability_zone = "${data.aws_region.current.name}${var.AZ2}"

  tags = {
    Name = "${aws_vpc.vpc.tags.Name}-${var.Int_Transit_Suffix}-az${var.AZ2}"
  }
}

#  Route Tables
resource "aws_route_table" "inspect" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${aws_vpc.vpc.tags.Name}-${var.Inspect_Suffix}-rt"
  }
}

resource "aws_route" "inspect_default" {
  route_table_id         = aws_route_table.inspect.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_route_table" "int_transit" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${aws_vpc.vpc.tags.Name}-${var.Int_Transit_Suffix}-rt"
  }
}

resource "aws_route" "int_transit_default" {
  count                  = var.South_North_Gateway_ENI != "" ? 1 : 0
  route_table_id         = aws_route_table.int_transit.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.South_North_Gateway_ENI # Usually FGT AZ1 ID
}

# Routing Table Associations
resource "aws_route_table_association" "inspect_az1" {
  subnet_id      = aws_subnet.inspect_az1.id
  route_table_id = aws_route_table.inspect.id
}

resource "aws_route_table_association" "inspect_az2" {
  subnet_id      = aws_subnet.inspect_az2.id
  route_table_id = aws_route_table.inspect.id
}

resource "aws_route_table_association" "int_transit_az1" {
  subnet_id      = aws_subnet.int_transit_az1.id
  route_table_id = aws_route_table.int_transit.id
}

resource "aws_route_table_association" "int_transit_az2" {
  subnet_id      = aws_subnet.int_transit_az2.id
  route_table_id = aws_route_table.int_transit.id
}

## Outputs
output "aws_subnet_inspect_az1" {
  value = aws_subnet.inspect_az1
}
output "aws_subnet_inspect_az1_id" {
  value = aws_subnet.inspect_az1.id
}
output "aws_subnet_inspect_az2" {
  value = aws_subnet.inspect_az2
}
output "aws_subnet_inspect_az2_id" {
  value = aws_subnet.inspect_az2.id
}
output "aws_subnet_int_transit_az1" {
  value = aws_subnet.int_transit_az1
}
output "aws_subnet_int_transit_az1_id" {
  value = aws_subnet.int_transit_az1.id
}
output "aws_subnet_int_transit_az2" {
  value = aws_subnet.int_transit_az2
}
output "aws_subnet_int_transit_az2_id" {
  value = aws_subnet.int_transit_az2.id
}
output "aws_route_table_inspect" {
  value = aws_route_table.inspect
}
output "aws_route_table_inspect_id" {
  value = aws_route_table.inspect.id
}