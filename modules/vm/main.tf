terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.52.0"
    }
  }
}
resource "openstack_compute_instance_v2" "vm"{
    for_each = {
        for vm in var.vm_details :vm.name => vm 
    }
    
    name       = each.value.name
    image_id   = each.value.image_id
    flavor_name  = each.value.flavor_name
    key_pair   = each.value.key_pair

    security_groups = each.value.security_groups
    
    network {
        uuid = var.network_id
    }
}