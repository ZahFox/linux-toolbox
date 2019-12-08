# Terraform

## Install

### Arch Linux

```bash
sudo pacman -Syu terraform
```

#### Create an SSH Key Pair for Terraform

```bash
PRE=$HOME/.ssh/terraform && \
ssh-keygen -t rsa -b 2048 -f $PRE -q -P '' && \
mv $PRE ${PRE}.pem && chmod 400 ${PRE}.pem
```

## Usage

Terraform has four essential commands for deploying infrastructure:

- `terraform init`
- `terraform plan`
- `terraform apply`
- `terraform destory`
