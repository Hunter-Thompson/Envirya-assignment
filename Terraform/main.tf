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
  # The connection block tells our provisioner how to
  # communicate with the resource (instance)
  connection {
    type = "ssh"
    # The default username for our AMI
    user = "ubuntu"
    host = self.public_ip
    # The connection will use the local SSH agent for authentication.
  }
  iam_instance_profile = aws_iam_instance_profile.s3_profile.name

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = var.personal_ami

  # The name of our SSH keypair we created above.
  key_name = aws_key_pair.auth.id

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = [aws_security_group.default.id]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = module.vpc.private_subnets[0]

}