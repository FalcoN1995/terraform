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
  security_groups = ["prod"]
  network {
    name = "private"
  }

  depends_on = [
    openstack_networking_floatingip_v2.fip1,
  ]

}

resource "openstack_networking_floatingip_v2" "fip1" {
  pool = "public"
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

