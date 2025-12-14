terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.52.0"
    }
  }
}

resource "openstack_networking_network_v2" "k8s-net" {
  name           = var.network_name
  admin_state_up = var.network_admin_state
}

resource "openstack_networking_subnet_v2" "k8s-subnet" {
    name        = var.subnet_name
    network_id  = openstack_networking_network_v2.k8s-net.id
    cidr        = var.k8s_sub_cidr
    ip_version  = 4
    enable_dhcp = true
}