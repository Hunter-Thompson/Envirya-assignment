#!/bin/bash
source ami_id \
&& cd Terraform \
&& yes yes | terraform destroy -var personal_ami=$AMI_ID \
&& rm -rf .terraform terraform.* \
