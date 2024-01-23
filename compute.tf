resource "openstack_compute_instance_v2" "instance" {
  count       = var.nb_instances
  name        = count.index < var.nb_masters ? "Rancher master N°${count.index}": "Rancher worker N°${count.index - var.nb_masters}"
  image_name  = "Debian-12"
  flavor_name = "m1.small"
  key_pair    = var.key_name

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