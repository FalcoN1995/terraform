output "ip" {
    value = openstack_compute_instance_v2.vm1.access_ip_v4
    description = "instacne ip"
}

