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

resource "openstack_networking_router_v2" "k8s-router" {
  name                = var.router_name
  admin_state_up      = var.network_admin_state
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "k8s-router-interface" {
  router_id = openstack_networking_router_v2.k8s-router.id
  subnet_id = openstack_networking_subnet_v2.k8s-subnet.id
}

resource "openstack_networking_secgroup_v2" "sg-workers" {
  name = var.sg_workers
  description= "Security grup for workers nodes"
}

resource "openstack_networking_secgroup_v2" "sg-control-plane" {
    name = var.sg_control_plane
    description = "Control plane security group"
}

resource "openstack_networking_secgroup_rule_v2" "sg-control-plane-rules_1" {
  security_group_id = openstack_networking_secgroup_v2.sg-control-plane.id
  ethertype         = var.ethertype
  direction         = var.direction_sg_cp
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.remote_ip_allowed
}

resource "openstack_networking_secgroup_rule_v2" "sg-control-plane-rules_2" {
  security_group_id = openstack_networking_secgroup_v2.sg-control-plane.id
  ethertype         = var.ethertype
  direction         = var.direction_sg_cp
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_group_id   = openstack_networking_secgroup_v2.sg-workers.id
}

#Sg rules for worker nodes
resource "openstack_networking_secgroup_rule_v2" "sg-worker-nodes-1" {
  security_group_id = openstack_networking_secgroup_v2.sg-workers.id
  ethertype         = var.ethertype
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.remote_ip_allowed
}

resource "openstack_networking_secgroup_rule_v2" "sg-worker-nodes-2" {
  security_group_id = openstack_networking_secgroup_v2.sg-workers.id
  ethertype         = var.ethertype
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_group_id   = openstack_networking_secgroup_v2.sg-control-plane.id
}

resource "openstack_networking_secgroup_rule_v2" "sg-worker-nodes-3" {
  security_group_id = openstack_networking_secgroup_v2.sg-workers.id
  ethertype         = var.ethertype
  direction         = "ingress"
  remote_group_id   = openstack_networking_secgroup_v2.sg-workers.id
}
