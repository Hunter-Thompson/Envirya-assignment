
# # Create a VPC to launch our instances into
# resource "aws_vpc" "default" {
#   cidr_block = "10.0.0.0/16"
# }

# # Create an internet gateway to give our subnet access to the outside world
# resource "aws_internet_gateway" "default" {
#   vpc_id = module.vpc.vpc_id
# }

# # Grant the VPC internet access on its main route table
# resource "aws_route" "internet_access" {
#   route_table_id         = aws_vpc.default.main_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.default.id
# }

# # Create a subnet to launch our instances into


# resource "aws_subnet" "default2" {
#   vpc_id                  = module.vpc.vpc_id
#   cidr_block              = "10.0.2.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "us-west-2c"

# }

# resource "aws_subnet" "default" {
#   vpc_id                  = module.vpc.vpc_id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "us-west-2a"

# }



data "aws_security_group" "default" {
  name   = "default"
  vpc_id = module.vpc.vpc_id
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "test"

  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "public-vpc"
  }

}