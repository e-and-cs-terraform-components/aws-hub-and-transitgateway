# Terraform Components: AWS Hub and Transit Gateway

You may find this module useful if you're building a "Hub and Spoke" layout network, as advocated
by various security firms, including Check Point and FortiNet.

## Role: Create AWS Hub VPC and Transit Gateway, plus additional connectivity

This role creates:

1. A single VPC, referred to as a "Security Hub" or just a "Hub", with at least two subnets
attached. These subnets are referred to as "Inspect" and "Internal Transit".
2. An Internet Gateway, to permit outbound traffic to The Internet.
3. A Transit Gateway, providing access to other Attached VPCs (referred to as Spokes).
4. A Security Group, permitting "any" inbound and outbound internet access.

Optionally, this role also creates a VPC Flow Log, associated to the VPC. It requires a Global
IAM Role to be created and passed to this module, and also to have the VPC Flow Logs explicitly
enabled.

## Variables

* Defined in `_General.tf`.
  * `Project_Prefix`: This is the name associated to all resources created. Default: `demo`.
  * `AZ1`: The AZ to create all assets associated to the "first" AZ. If the region is `us-east-1`,
  the AZ `us-east-1a` would be recorded as `a`. Default: `a`.
  * `AZ2`: The AZ to create all assets associated ot the "second" AZ. Default: `b`.
* Defined in `VPC.tf`
  * `VPC_Suffix`: The suffix for the VPC, referenced in some other assets, like subnets and VPC
  flow logs. Default: `secub`.
  * `IAM_Role_VPC_Flow_Logs_ARN`: The ARN (AWS Resource Name) for the IAM role which permits the
  creation of, and write access to a Cloudwatch Log Group, and this permits the VPC to write it's
  logs into this group. **Without this role being provided, flow logs will not be created.**
  Default: `null`.
  * `VPC_CIDR`: The CIDR mask of the VPC. It must be large enough to support 4 subnets. If you want
  to add additional subnets for your security appliances, then you must make sure this VPC is large
  enough to support them. Default: `192.0.2.0/24`.
  * `Enable_VPC_Flow_Logs`: Combined with `IAM_Role_VPC_Flow_Logs_ARN`, does this permit the VPC
  to create VPC flow logs? Default: `false`.
* Defined in `Internet Gateway.tf`
  * `InternetGateway_Suffix`: The suffix of the Internet Gateway created in this VPC. Default:
  `igw`.
* Defined in `Subnets.tf`
  * `Inspect_Suffix`: The name for the created subnets in AZ1 and AZ2, attached to the VPC which
  **inspect** ingress and egress traffic. Default: `inspect`.
  * `Int_Transit_Suffix`: The name for the created subnets in AZ1 and AZ2, attached to the VPC to
  route traffic from the Transit Gateway to the Appliance(s) which **Inspect** traffic. Default:
  `int_transit`.
  * `Subnet_Inspect_AZ1_CIDR`: The CIDR for the `inspect` subnet in AZ1. Default: `192.0.2.0/28`.
  * `Subnet_Inspect_AZ2_CIDR`: The CIDR for the `inspect` subnet in AZ2. Default: `192.0.2.16/28`.
  * `Subnet_Internal_Transit_AZ1_CIDR`: The CIDR for the `int_transit` subnet in AZ1. Default:
  `192.0.2.32/28`.
  * `Subnet_Internal_Transit_AZ2_CIDR`: The CIDR for the `int_transit` subnet in AZ2. Default:
  `192.0.2.48/28`.
  * `South_North_Gateway_ENI`: The ENI (Elastic Network Interface) ID for the interface to route
  traffic from the `int_transit` towards.
* Defined in `Transit Gateway.tf`
  * `TransitGateway_Suffix`: The suffix for the Transit Gateway. Default: `Transit_Gateway`.
