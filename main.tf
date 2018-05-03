terraform {
  required_version = ">= 0.11.7"
}

variable "gcp_credentials" {
  description = "GCP credentials needed by google provider"
}

variable "gcp_project" {
  description = "GCP project name"
}

//--------------------------------------------------------------------
// Variables
variable "compute_instance_count" {}
variable "compute_instance_disk_image" {}
variable "compute_instance_disk_size" {}
variable "compute_instance_machine_type" {}
variable "compute_instance_region" {}
variable "network_firewall_target_tags" {}
variable "network_subnet_description" {}
variable "network_description" {}

provider "google" {
  credentials = "${var.gcp_credentials}"
  project     = "${var.gcp_project}"
  region      = "${var.compute_instance_region}"
}

//--------------------------------------------------------------------
// Modules
module "compute_instance" {
  source  = "app.terraform.io/RogerBerlind/compute-instance/google"
  version = "0.1.1"

  count = "${var.compute_instance_count}"
  disk_image = "${var.compute_instance_disk_image}"
  disk_size = "${var.compute_instance_disk_size}"
  machine_type = "${var.compute_instance_machine_type}"
  name_prefix = "citi-demo"
  region = "${var.compute_instance_region}"
  subnetwork = "${module.network_subnet.self_link}"
  user_data = "echo hello"
}

module "network_firewall" {
  source  = "app.terraform.io/RogerBerlind/network-firewall/google"
  version = "0.1.2"

  name = "allow_80"
  network = "${module.network.self_link}"
  ports = [80]
  priority = "Allow Port 80 ingress"
  protocol = "TCP"
  source_ranges = "0.0.0.0/0"
  target_tags = "${var.network_firewall_target_tags}"
}

module "network_subnet" {
  source  = "app.terraform.io/RogerBerlind/network-subnet/google"
  version = "0.1.2"

  description = "${var.network_subnet_description}"
  ip_cidr_range = "172.17.0.0/16"
  name = "citi-subnet"
  vpc = "${module.network.self_link}"
}

module "network" {
  source  = "app.terraform.io/RogerBerlind/network/google"
  version = "0.1.3"

  auto_create_subnetworks = "false"
  description = "${var.network_description}"
  name = "citi-demo"
}
