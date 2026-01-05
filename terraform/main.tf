terraform {
  required_version = ">= 1.0"
  
  required_providers {
    # Add your required providers here
    # Example for local provider:
    # local = {
    #   source  = "hashicorp/local"
    #   version = "~> 2.0"
    # }
  }
  
  # Configure backend for remote state (recommended)
  # backend "s3" {
  #   bucket = "my-terraform-state"
  #   key    = "homelab/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

# Example provider configuration
# provider "proxmox" {
#   pm_api_url      = var.proxmox_api_url
#   pm_user         = var.proxmox_user
#   pm_password     = var.proxmox_password
#   pm_tls_insecure = true
# }
