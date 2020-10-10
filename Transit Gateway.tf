## Variables
# Naming
variable "TransitGateway_Suffix" {
  type        = string
  default     = "Transit_Gateway"
  description = "The string to add to the name of the Transit Gateway after the project prefix and a hyphen (e.g. 'demo-Transit_Gateway')"
}

## Resources
# Transit Gateway
resource "aws_ec2_transit_gateway" "defined" {
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name = "${var.Project_Prefix}-${var.TransitGateway_Suffix}"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "hub" {
  transit_gateway_default_route_table_association = false
  transit_gateway_default_route_table_propagation = false

  subnet_ids         = [aws_subnet.int_transit_az1.id, aws_subnet.int_transit_az2.id]
  transit_gateway_id = aws_ec2_transit_gateway.defined.id
  vpc_id             = aws_vpc.vpc.id

  tags = {
    Name = "${aws_ec2_transit_gateway.defined.tags.Name}-attach-${aws_vpc.vpc.tags.Name}"
  }
}

#  Route Tables
resource "aws_ec2_transit_gateway_route_table" "hub_to_spokes" {
  transit_gateway_id = aws_ec2_transit_gateway.defined.id
  tags = {
    Name = "${aws_ec2_transit_gateway.defined.tags.Name}-attach-${aws_vpc.vpc.tags.Name}-rt"
  }
}

resource "aws_ec2_transit_gateway_route_table" "spokes_to_hub" {
  transit_gateway_id = aws_ec2_transit_gateway.defined.id
  tags = {
    Name = "${aws_ec2_transit_gateway.defined.tags.Name}-attach-SPOKES_TO_HUB-rt"
  }
}

resource "aws_ec2_transit_gateway_route" "spokes_default" {
  destination_cidr_block         = "0.0.0.0/0"
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.spokes_to_hub.id
}

# Routing Table Attachments / Associations
resource "aws_ec2_transit_gateway_route_table_association" "hub" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.hub.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.hub_to_spokes.id
}

## Outputs
output "aws_ec2_transit_gateway_defined" {
  value = aws_ec2_transit_gateway.defined
}
output "aws_ec2_transit_gateway_defined_id" {
  value = aws_ec2_transit_gateway.defined.id
}
output "aws_ec2_transit_gateway_vpc_attachment_hub" {
  value = aws_ec2_transit_gateway_vpc_attachment.hub
}
output "aws_ec2_transit_gateway_vpc_attachment_hub_id" {
  value = aws_ec2_transit_gateway_vpc_attachment.hub.id
}
output "aws_ec2_transit_gateway_route_table_hub_to_spokes" {
  value = aws_ec2_transit_gateway_route_table.hub_to_spokes
}
output "aws_ec2_transit_gateway_route_table_hub_to_spokes_id" {
  value = aws_ec2_transit_gateway_route_table.hub_to_spokes.id
}
output "aws_ec2_transit_gateway_route_table_spokes_to_hub" {
  value = aws_ec2_transit_gateway_route_table.spokes_to_hub
}
output "aws_ec2_transit_gateway_route_table_spokes_to_hub_id" {
  value = aws_ec2_transit_gateway_route_table.spokes_to_hub.id
}
output "aws_ec2_transit_gateway_route_spokes_default" {
  value = aws_ec2_transit_gateway_route.spokes_default
}
output "aws_ec2_transit_gateway_route_spokes_default_id" {
  value = aws_ec2_transit_gateway_route.spokes_default.id
}
