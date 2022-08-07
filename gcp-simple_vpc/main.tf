terraform {

}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region # seoul
  zone    = var.zone
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network
resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      # gcloud compute images list로 찾는게 빠름
      # https://cloud.google.com/compute/docs/images#gcloud
      image = "centos-7-v20220719"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
    }
  }
}
