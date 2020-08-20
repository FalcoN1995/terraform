provider "openstack" {
  user_name   = "puser"
  tenant_name = "prod"
  password    = "dkagh1."
  auth_url    = "http://192.168.122.250:5000"
  region      = "RegionOne"
}


resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm1"
  image_name      = var.iname
  flavor_name     = var.fname
  key_pair        = "key1"
  security_groups = var.sg_list
  network {
    name = "private"
  }
}

