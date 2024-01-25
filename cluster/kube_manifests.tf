resource "kubernetes_secret" "openstack_cloud_provider" {
  metadata {
    name      = "openstack-cloud-provider"
    namespace = "kube-system"
  }

  data = {
    "cloud.conf" = <<-EOF
  [Global]
  auth-url = ${var.auth_url}
  username = ${var.username}
  password = ${var.password}
  region = regionOne
  tls-insecure = true

  [LoadBalancer]
  use-octavia=true
  floating-network-id=${data.openstack_networking_network_v2.public_net.id}
  subnet-id=${openstack_networking_subnet_v2.subnet_1.id}
  EOF
  }
}