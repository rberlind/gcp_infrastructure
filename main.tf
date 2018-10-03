// Terraform Variables
variable "gcp_credentials" {
  description = "GCP credentials needed by google provider"
}

variable "gcp_project" {
  description = "GCP project name"
}

variable "gcp_region" {
 description = "GCP region"
 default = "us-east1"
}

// Google Provider Configuration
provider "google" {
  credentials = "${var.gcp_credentials}"
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
}

// -------------------------------------------------------------------
// 'Insert Terraform code generated by the Configuration Designer here
// -------------------------------------------------------------------




// -------------------------------------------------------------------

// Terraform outputs
output "network_name" {
  value = "${module.network.name}"
}
  
output "subnet_gateway_address" {
  value = "${module.network_subnet.gateway_address}"
} 
  
output "firewall_self_link" {
  value = "${module.network_firewall.self_link}"
}
  
output "compute_instance_addresses" {
  value = "${module.compute_instance.addresses}"
}  
