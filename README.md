# Assignment

## Dependencies:
Terraform
```sh
v0.13.0
```
Packer
```sh
v1.6.1
```

## Variables to export to ENV
```sh
export AWS_ACCESS_KEY=
export AWS_SECRET_KEY=
```

## Variables to add in Terraform/terraform.tfvars
```sh
#Name of the keypair created in AWS
key_name             = ""
#Path to your public SSH key
public_key_path      = ""
#Domain name of your application, e,g dev.example.com
d_name               = ""
#Primary zone name of your application, e.g example.com
primary_zone_address = ""
```

## Bring the ENV up
```sh
./run.sh
```

## Bring the ENV down
```sh
./clean.sh
```