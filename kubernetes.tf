resource "rke_cluster" "cluster" {
  cluster_name = "rancher-cluster"
  cluster_yaml = yamlencode({
    "nodes" : concat([
      for m in slice(openstack_networking_floatingip_v2.floatingip, 0, var.nb_masters + 1) :
      {
        "address" : m.address,
        "role" : [
          "controlplane",
          "etcd"
        ],
        "user" : "debian"
      }
      ], [
      for s in slice(openstack_networking_floatingip_v2.floatingip, var.nb_masters + 1, var.nb_instances) :
      {
        "address" : s.address,
        "role" : [
          "worker"
        ],
        "user" : "debian"
      }
    ])
  })

  ssh_key_path       = var.ssh_key_path
  enable_cri_dockerd = true

  delay_on_creation = 180

  depends_on = [
    openstack_compute_instance_v2.instance, 
    openstack_networking_floatingip_v2.floatingip
  ]
}

resource "local_file" "kubeconfig" {
  content  = rke_cluster.cluster.kube_config_yaml
  filename = "${path.module}/kubeconfig"
}