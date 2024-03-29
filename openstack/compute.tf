resource "openstack_compute_instance_v2" "instance" {
  count       = var.nb_instances
  name        = count.index < var.nb_masters ? "Rancher master N°${count.index + 1}" : "Rancher worker N°${count.index - var.nb_masters + 1}"
  image_name  = "Debian-12-raw"
  flavor_name = "m1.medram"
  key_pair    = openstack_compute_keypair_v2.ssh.name

  security_groups = [
    openstack_networking_secgroup_v2.kube.name,
  ]

  tags = [
    "terraform",
  ]

  network {
    uuid = openstack_networking_subnet_v2.subnet_1.network_id
  }

  user_data = file("${path.module}/scripts/install_docker.sh")
}

resource "openstack_compute_keypair_v2" "ssh" {
  name = "yann"
  region = var.region_name
  public_key = file(var.ssh_pub_key_path)
}

# resource "local_file" "ssh_key" {
#   filename = "ssh_key"
#   file_permission = "0600"
#   content = openstack_compute_keypair_v2.ssh.private_key
# }

# resource "local_file" "ssh_key_pub" {
#   filename = "ssh_key_pub"
#   file_permission = "0600"
#   content = openstack_compute_keypair_v2.ssh.public_key
# }

resource "openstack_networking_secgroup_v2" "kube" {
  name        = "kubernetes"
  description = "my security group for kube"
}

resource "openstack_networking_secgroup_rule_v2" "allow_kubeapi" {
  security_group_id = openstack_networking_secgroup_v2.kube.id

  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 6443
  port_range_max   = 6443
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "allow_ssh" {
  security_group_id = openstack_networking_secgroup_v2.kube.id

  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 22
  port_range_max   = 22
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "allow_etcd_clients" {
  security_group_id = openstack_networking_secgroup_v2.kube.id

  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 2379
  port_range_max   = 2379
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "allow_etcd_peer_in" {
  security_group_id = openstack_networking_secgroup_v2.kube.id

  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 2380
  port_range_max   = 2380
  remote_ip_prefix = "0.0.0.0/0"
}


resource "openstack_networking_secgroup_rule_v2" "allow_etcd_peer_out" {
  security_group_id = openstack_networking_secgroup_v2.kube.id

  direction        = "egress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 2380
  port_range_max   = 2380
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "allow_metrics_server" {
  security_group_id = openstack_networking_secgroup_v2.kube.id

  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 10250
  port_range_max   = 10250
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "allow_https_in" {
  security_group_id = openstack_networking_secgroup_v2.kube.id

  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 443
  port_range_max   = 443
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "allow_https_out" {
  security_group_id = openstack_networking_secgroup_v2.kube.id

  direction        = "egress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 443
  port_range_max   = 443
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "allow_http_in" {
  security_group_id = openstack_networking_secgroup_v2.kube.id

  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 80
  port_range_max   = 80
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "allow_http_out" {
  security_group_id = openstack_networking_secgroup_v2.kube.id

  direction        = "egress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 80
  port_range_max   = 80
  remote_ip_prefix = "0.0.0.0/0"
}

resource "openstack_networking_secgroup_rule_v2" "allow_10248" {
  security_group_id = openstack_networking_secgroup_v2.kube.id

  direction        = "ingress"
  ethertype        = "IPv4"
  protocol         = "tcp"
  port_range_min   = 10248
  port_range_max   = 10248
  remote_ip_prefix = "0.0.0.0/0"

}