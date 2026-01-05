# Terraform Infrastructure

This directory contains Terraform configurations for provisioning homelab infrastructure.

## Structure

```
terraform/
├── main.tf              # Main configuration
├── variables.tf         # Variable definitions
├── outputs.tf          # Output definitions
├── providers.tf        # Provider configurations
└── modules/            # Reusable modules
```

## Prerequisites

- Terraform installed (`brew install terraform` or download from terraform.io)
- Cloud provider credentials (if using cloud resources)

## Quick Start

### Initialize Terraform

```bash
terraform init
```

### Plan Changes

```bash
# See what will be created/changed
terraform plan

# Save plan to file
terraform plan -out=tfplan
```

### Apply Changes

```bash
# Apply changes
terraform apply

# Apply with saved plan
terraform apply tfplan

# Auto-approve (skip confirmation)
terraform apply -auto-approve
```

### Destroy Resources

```bash
terraform destroy
```

## Configuration

### Variables

Define variables in `variables.tf`:

```hcl
variable "region" {
  description = "Cloud region"
  type        = string
  default     = "us-east-1"
}
```

Use in `terraform.tfvars`:

```hcl
region = "us-west-2"
```

Or pass via command line:

```bash
terraform apply -var="region=us-west-2"
```

### State Management

**Important**: Secure your state files!

For remote state (recommended):

```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "homelab/terraform.tfstate"
    region = "us-east-1"
  }
}
```

## Common Commands

```bash
# Format code
terraform fmt -recursive

# Validate configuration
terraform validate

# Show current state
terraform show

# List resources
terraform state list

# Import existing resource
terraform import <resource_type>.<name> <id>

# Refresh state
terraform refresh
```

## Modules

Create reusable modules:

```
modules/
└── compute/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

Use module:

```hcl
module "compute" {
  source = "./modules/compute"
  
  instance_count = 2
  instance_type  = "t3.micro"
}
```

## Best Practices

- Use version control for configurations
- Store state remotely and securely
- Use workspaces for environments
- Lock provider versions
- Use variables for flexibility
- Document your code
- Use modules for reusability
- Never commit secrets
- Use `.terraform.lock.hcl` for reproducibility

## Example Providers

### Proxmox

```hcl
terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_user    = var.proxmox_user
  pm_password = var.proxmox_password
}
```

### VMware vSphere

```hcl
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
}
```

## Troubleshooting

```bash
# Enable debug logging
export TF_LOG=DEBUG
terraform apply

# Unlock state (if stuck)
terraform force-unlock <lock-id>

# Recreate resource
terraform taint <resource>
terraform apply
```
