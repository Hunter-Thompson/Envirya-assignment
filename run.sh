#!/bin/bash

cd Packer \
&& packer build -var "aws_access_key=$AWS_ACCESS_KEY" -var "aws_secret_key=$AWS_SECRET_KEY" envirya.json \
&& AMI_ID=$(jq -r '.builds[-1].artifact_id' manifest.json | cut -d ":" -f2) \
&& echo AMI_ID=$AMI_ID > ami_id \
&& source ami_id \ 
&& cd ../Terraform \
&& yes yes | terraform init \
&& yes yes | terraform apply -var personal_ami=$AMI_ID
