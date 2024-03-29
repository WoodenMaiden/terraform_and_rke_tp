terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.53.0"
    }
    k0s = {
      source  = "danielskowronski/k0s"
      version = "0.2.2-rc1"
    }
  }
}

provider "k0s" {}

provider "openstack" {
  tenant_id = var.project_id
  auth_url  = var.auth_url
  user_name = var.username
  password  = var.password
  region    = var.region_name
  insecure  = true
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