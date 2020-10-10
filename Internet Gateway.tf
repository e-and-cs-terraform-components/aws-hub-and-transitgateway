## Variables
variable "InternetGateway_Suffix" {
  type        = string
  default     = "igw"
  description = "The string to add to the name of the Internet Gateway after the project prefix and a hyphen (e.g. 'demo-igw')"
}

## Resources
# InternetGateway
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${aws_vpc.vpc.tags.Name}-${var.InternetGateway_Suffix}"
  }
}

## Output
output "aws_internet_gateway_gateway" {
  value = aws_internet_gateway.gateway
}
output "aws_internet_gateway_gateway_id" {
  value = aws_internet_gateway.gateway.id
}