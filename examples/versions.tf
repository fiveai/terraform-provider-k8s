terraform {
  required_providers {
    k8s = {
      source = "fiveai/k8s"
      version = "0.2.1"
    }
  }
}

provider "k8s" {
  # Configuration options
}
