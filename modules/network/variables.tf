variable "network_name" {}
variable "network_admin_state" {}
variable "subnet_name" { default = "k8s_subnet" }
variable "router_name" { default = "k8s_router" }
variable "sg_control_plane" { default = "sg_control_plane" }
variable "external_network_id" {}
variable "k8s_sub_cidr" {}
variable "direction_sg_cp" { default = "ingress"}
variable "remote_ip_allowed" {}
variable "ethertype" { default = "IPv4" }
variable "sg_workers" { default = "sg_worker_nodes"}