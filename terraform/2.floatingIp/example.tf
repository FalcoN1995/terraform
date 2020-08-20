provider "openstack" {
  user_name   = "puser"
  tenant_name = "prod"
  password    = "dkagh1."
  auth_url    = "http://192.168.122.250:5000"
  region      = "RegionOne"
}


resource "openstack_compute_instance_v2" "vm3" {
  name            = "vm3"
  image_name      = "centos"
  flavor_name     = "default"
  key_pair        = "key1"
  security_groups = ["prod"]
  network {
    name = "private"
  }
  depends_on = [openstack_networking_floatingip_v2.fip1]
}

resource "openstack_compute_instance_v2" "vm2" {
  name            = "vm2"
  image_name      = "cirros"
  flavor_name     = "default"
  key_pair        = "key1"
  security_groups = ["prod"]
  network {
    name = "private"
  }
}

resource "openstack_networking_floatingip_v2" "fip1" {
  pool = "public"
}

resource "openstack_compute_floatingip_associate_v2" "myip" {
  floating_ip 	= openstack_networking_floatingip_v2.fip1.address
  instance_id   = openstack_compute_instance_v2.vm3.id
}

