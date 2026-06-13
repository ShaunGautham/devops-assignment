terraform {
  backend "local" {}
}

# This file intentionally left minimal
# All resources are defined in:
# - vpc.tf
# - gke.tf
# - nodepool.tf