terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = ">= 1.52.0"
    
    }
  }
}

resource "openstack_networking_network_v2" "k8s_net" {
  name           = var.network_name
  admin_state_up = var.network_admin_state
}

resource "openstack_networking_subnet_v2" "k8s_subnet" {
    name        = var.subnet_name
    network_id  = openstack_networking_network_v2.k8s_net.id
    cidr        = var.k8s_sub_cidr
    ip_version  = 4
    enable_dhcp = true
    dns_nameservers = [
    "8.8.8.8",
    "1.1.1.1"
  ]
}

resource "openstack_networking_router_v2" "k8s_router" {
  name                = var.router_name
  admin_state_up      = var.network_admin_state
  external_network_id = var.external_network_id
}

resource "openstack_networking_router_interface_v2" "k8s_router_interface" {
  router_id = openstack_networking_router_v2.k8s_router.id
  subnet_id = openstack_networking_subnet_v2.k8s_subnet.id
}

resource "openstack_networking_secgroup_v2" "sg_workers" {
  name = var.sg_workers
  description= "Security grup for workers nodes"
}

resource "openstack_networking_secgroup_v2" "sg_control_plane" {
    name = var.sg_control_plane
    description = "Control plane security group"
}

#Sg rules for control    plane node
resource "openstack_networking_secgroup_rule_v2" "sg_control_plane_rules_1" {
  security_group_id = openstack_networking_secgroup_v2.sg_control_plane.id
  ethertype         = var.ethertype
  direction         = var.direction_sg_cp
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.remote_ip_allowed
}

resource "openstack_networking_secgroup_rule_v2" "sg_control_plane_rules_2" {
  security_group_id = openstack_networking_secgroup_v2.sg_control_plane.id
  ethertype         = var.ethertype
  direction         = var.direction_sg_cp
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_group_id   = openstack_networking_secgroup_v2.sg_workers.id
}

resource "openstack_networking_secgroup_rule_v2" "cp_ssh_from_bastion" {
  security_group_id = openstack_networking_secgroup_v2.sg_control_plane.id
  ethertype         = var.ethertype
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = openstack_networking_secgroup_v2.sg_bastion.id
}

#Sg rules for worker nodes
resource "openstack_networking_secgroup_rule_v2" "sg_worker_nodes_ssh" {
  security_group_id = openstack_networking_secgroup_v2.sg_workers.id
  ethertype         = var.ethertype
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.remote_ip_allowed
}

resource "openstack_networking_secgroup_rule_v2" "sg_worker_nodes_ip" {
  security_group_id = openstack_networking_secgroup_v2.sg_workers.id
  ethertype         = var.ethertype
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 10250
  port_range_max    = 10250
  remote_group_id   = openstack_networking_secgroup_v2.sg_control_plane.id
}

resource "openstack_networking_secgroup_rule_v2" "sg_worker_nodes_ssh_permision" {
  security_group_id = openstack_networking_secgroup_v2.sg_workers.id
  ethertype         = var.ethertype
  direction         = "ingress"
  remote_group_id   = openstack_networking_secgroup_v2.sg_workers.id
}

resource "openstack_networking_secgroup_rule_v2" "worker_ssh_from_bastion" {
  security_group_id = openstack_networking_secgroup_v2.sg_workers.id
  ethertype         = var.ethertype
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_group_id   = openstack_networking_secgroup_v2.sg_bastion.id
}

#Sg for bastion
resource "openstack_networking_secgroup_v2" "sg_bastion" {
  name = var.sg_bastion
  description= "Security grup for bastion node"
}

resource "openstack_networking_secgroup_rule_v2" "sg_bastion_ssh" {
  security_group_id = openstack_networking_secgroup_v2.sg_bastion.id
  ethertype         = var.ethertype
  direction         = "ingress"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.remote_ip_allowed
}







