resource "k0s_cluster" "cluster" {
  name = "k0s-cluster"
  version = "1.27.2+k0s.0"

  hosts = concat([
    for index, m in slice(openstack_networking_floatingip_v2.floatingip, 0, var.nb_masters + 1) :
    {
      role = "controller",

      # private_address = openstack_compute_instance_v2.instance[index].network.0.fixed_ip_v4

      ssh = {
        address  = m.address
        port     = 22
        user     = "debian"
      }
    }
    ], [
    for index, s in slice(openstack_networking_floatingip_v2.floatingip, var.nb_masters + 1, var.nb_instances) :
    {
      role = "worker",


      # private_address = openstack_compute_instance_v2.instance[index + var.nb_masters + 1].network.0.fixed_ip_v4

      ssh = {
        address  = s.address
        port     = 22
        user     = "debian"
      }
    }
  ])

  depends_on = [
    openstack_compute_instance_v2.instance,
    openstack_networking_floatingip_v2.floatingip
  ]
}

resource "local_file" "kubeconfig" {
  content  = k0s_cluster.cluster.kubeconfig
  filename = "${path.module}/kubeconfig"
}

resource "helm_release" "openstack-cloud-controller-manager" {
  repository = "https://kubernetes.github.io/cloud-provider-openstack"
  chart = "openstack-cloud-controller-manager"

  name = "openstack-cloud-controller-manager"

  set {
    name = "cloudConfig.global.auth-url"
    value = var.auth_url
  }

  set {
    name = "cloudConfig.global.username"
    value = var.username
  }

  set {
    name = "cloudConfig.global.password"
    value = var.password
  }

  set {
    name = "cloudConfig.loadBalancer.floating-subnet-id"
    value = openstack_networking_subnet_v2.subnet_1.id
  }

  set {
    name = "cloudConfig.loadBalancer.create-monitor"
    value = true
  }

  depends_on = [ k0s_cluster.cluster ]
}