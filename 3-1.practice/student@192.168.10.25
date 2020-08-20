provider "openstack" {
  user_name   = "puser"
  tenant_name = "prod"
  password    = "dkagh1."
  auth_url    = "http://192.168.122.250:5000"
  region      = "RegionOne"
}

resource "openstack_compute_instance_v2" "vm1" {
  name            = "vm1"
  image_name      = "centos"
  flavor_name     = "default"
  key_pair        = "key1"
  security_groups = [openstack_networking_secgroup_v2.secgroup_1.name]
  network {
    name = "private"
  }

  depends_on = [
    openstack_networking_floatingip_v2.fip1,
    openstack_networking_secgroup_v2.secgroup_1 
  ]

}

resource "openstack_networking_floatingip_v2" "fip1" {
  pool = "public"
}

resource "openstack_networking_secgroup_v2" "secgroup_1" {
  name        = "secgroup_1"
  description = "My neutron security group"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_3" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.secgroup_1.id
}

resource "openstack_blockstorage_volume_v2" "volume_1" {
  name = "volume_1"
  size = 1
}

resource "openstack_compute_volume_attach_v2" "va_1" {
  instance_id = openstack_compute_instance_v2.vm1.id
  volume_id   = openstack_blockstorage_volume_v2.volume_1.id
}



resource "openstack_compute_floatingip_associate_v2" "myip" {
  floating_ip = openstack_networking_floatingip_v2.fip1.address
  instance_id = openstack_compute_instance_v2.vm1.id

  connection {
    type = "ssh"
    user = "centos"
    private_key = file("~/.ssh/id_rsa")
    host = openstack_networking_floatingip_v2.fip1.address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum -y install httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "echo ${self.floating_ip} | sudo tee /var/www/html/index.html"
    ]
  }
  
  provisioner "local-exec" {
    command = "echo ${self.instance_id} > ./instance_id.txt"
  }

  provisioner "file" {
    source      = "filea.txt"
    destination = "/home/centos/filea.txt"
  }
}

