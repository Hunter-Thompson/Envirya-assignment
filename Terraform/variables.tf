variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Example: ~/.ssh/id_rsa.pub
DESCRIPTION
}

#The name of your keypair
variable "key_name" {
  description = "Desired name of AWS key pair"
}

#The region to deploy to
variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "us-west-2"
}

#AMI created by packer
variable "personal_ami" {
description = "AMI created by Packer"
}

#Name of your domain
variable "d_name" {
  description = "domain name"
}

#The address for the primary zone
variable "primary_zone_address" {
  description = "The primary zone address"
}