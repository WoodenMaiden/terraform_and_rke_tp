terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.53.0"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.4.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }
  }
}

provider "rke" {
  debug    = true
  log_file = "/tmp/rke.log"
}

provider "openstack" {
  tenant_id = var.project_id
  auth_url  = var.auth_url
  user_name = var.username
  password  = var.password
  region    = var.region_name
  insecure  = true
}

provider "helm" {
  kubernetes {
    config_path = local_file.kubeconfig.filename
  }
}

provider "kubernetes" {
  config_path = local_file.kubeconfig.filename
}

output "master_ips" {
  value = [for m in slice(openstack_networking_floatingip_v2.floatingip, 0, var.nb_masters) : m.address]
}

output "worker_ips" {
  value = [for s in slice(openstack_networking_floatingip_v2.floatingip, var.nb_masters, var.nb_instances) : s.address]
}

output "all" {
  value = [for f in openstack_networking_floatingip_v2.floatingip : f.address]
}

output "kubeconfig" {
  value = local_file.kubeconfig.filename
}