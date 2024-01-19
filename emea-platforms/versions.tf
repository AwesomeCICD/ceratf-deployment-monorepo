terraform {
  required_version = ">= 1.0"
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    nexus = {
      source  = "datadrivers/nexus"
    }
  }
}