provider "openstack" {
  user_name   = "puser"
  tenant_name = "prod"
  password    = "dkagh1."
  auth_url    = "http://192.168.122.250:5000"
  region      = "RegionOne"
}


resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm_with_terraform1"
  image_name      = "centos"
  flavor_name     = "default"
  key_pair        = "key1"
  security_groups = ["prod"]
  network {
    name = "private"
  }
}
