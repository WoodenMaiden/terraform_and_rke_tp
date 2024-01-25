terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.25.2"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = "../kubeconfig"
  }
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}
