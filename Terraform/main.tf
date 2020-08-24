terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = var.aws_region
}


resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}


resource "aws_instance" "web" {

  # Attach S3 IAM Polcy
  iam_instance_profile = aws_iam_instance_profile.s3_profile.name

  #Instance type
  instance_type = "t2.micro"

  #The AMI we created in Packer
  ami = var.personal_ami

  # The name of our SSH keypair we created above.
  key_name = aws_key_pair.auth.id

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = [aws_security_group.default.id]

  #Launch the instance in a private subnet
  subnet_id = module.vpc.private_subnets[0]

}