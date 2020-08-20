resource "openstack_networking_network_v2" "network_1" {
  name           = "net2"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "sub2"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = var.CIDR_BLOCK
  ip_version = 4
}

