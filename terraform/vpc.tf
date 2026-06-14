resource "google_compute_network" "vpc_network" {
  name = "vpc-network"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "subnet" {
  name          = "devops-subnet"
  ip_cidr_range = "10.0.0.0/24"
  network       = google_compute_network.vpc_network.id
  region        = var.region
}