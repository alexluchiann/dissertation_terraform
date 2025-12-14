terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.52.0"
    }
  }
}


provider "openstack" {
  auth_url                      = var.os_auth_url
  region                        = var.os_region
  application_credential_id     = var.os_app_cred_id
  application_credential_secret = var.os_app_cred_secret
}

module "network" {
  source              = "./modules/network"
  network_name        = var.network_name
  network_admin_state = var.network_admin_state
  k8s_sub_cidr        = var.k8s_sub_cidr
}
