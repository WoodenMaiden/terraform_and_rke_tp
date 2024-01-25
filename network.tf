data "openstack_networking_network_v2" "public_net" {
  name = "public"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "kube_subnet_1"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.199.0/24"
}

resource "openstack_networking_network_v2" "network_1" {
  name           = "kube_network_1"
  admin_state_up = "true"
}

resource "openstack_networking_floatingip_v2" "floatingip" {
  pool  = "public"
  count = var.nb_instances
}

resource "openstack_compute_floatingip_associate_v2" "floatip_assoc" {
  count       = var.nb_instances
  floating_ip = openstack_networking_floatingip_v2.floatingip.*.address[count.index]
  instance_id = openstack_compute_instance_v2.instance.*.id[count.index]
}


resource "openstack_networking_router_v2" "router_1" {
  name                = "tf_test_router"
  external_network_id = data.openstack_networking_network_v2.public_net.id
  admin_state_up      = true
}

resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}
