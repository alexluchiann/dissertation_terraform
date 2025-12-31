variable "os_auth_url" { }
variable "os_region" {}
variable "os_app_cred_id" {sensitive   = true}
variable "os_app_cred_secret" {sensitive   = true}
variable "network_name" {}
variable "vm_name" {}
variable "image_id" {}
variable "flavor_name" {}
variable "k8s_sub_cidr" {}
variable "network_admin_state" {}
variable "external_network_id" {}
variable "remote_ip_allowed" {}
variable "key_pair" {}
variable "worker_1_name" {}
variable "worker_2_name" {}
variable "worker_3_name" {}
variable "external_network_name" {}

