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
  external_network_id = var.external_network_id
  remote_ip_allowed   = var.remote_ip_allowed
}

module "vm" {
  source  = "./modules/vm"
  network_id = module.network.network_id
  vm_details = [
    {
      name  = "control-plane"
      image_id = var.image_id
      flavor_name = var.flavor_name
      key_pair = var.key_pair
      security_groups = ["sg_control_plane"]
    }
  ]
}
