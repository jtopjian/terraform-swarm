variable "worker_count" {
  default = 2
}

variable "floating_ip" {
  default = "CHANGEME"
}

variable "secgroup" {
  default = "CHANGEME"
}

resource "openstack_compute_keypair_v2" "swarm" {
  name = "swarm"
  public_key = "${file("key/id_rsa.pub")}"
}

resource "openstack_compute_instance_v2" "swarm-manager" {
  name = "swarm-manager"
  image_name = "Ubuntu 16.04"
  flavor_name = "m1.medium"
  key_pair = "swarm"
  security_groups = ["${var.secgroup}"]
  floating_ip = "${var.floating_ip}"
}

resource "openstack_compute_instance_v2" "swarm-workers" {
  count = "${var.worker_count}"
  name = "${format("swarm-worker-%02d", count.index+1)}"
  image_name = "Ubuntu 16.04"
  flavor_name = "m1.medium"
  key_pair = "swarm"
  security_groups = ["${var.secgroup}"]
}

resource "null_resource" "provision-swarm-manager" {
  provisioner "local-exec" {
    command = "files/create-swarm-manager.sh ${openstack_compute_instance_v2.swarm-manager.network.0.fixed_ip_v4} ${openstack_compute_instance_v2.swarm-manager.network.0.fixed_ip_v6} ${openstack_compute_instance_v2.swarm-manager.name} ${var.floating_ip}"
  }
}

resource "null_resource" "provision-swarm-workers" {
  depends_on = ["null_resource.provision-swarm-manager"]
  count = "${var.worker_count}"

  provisioner "local-exec" {
    command = "files/create-swarm-worker.sh ${openstack_compute_instance_v2.swarm-manager.network.0.fixed_ip_v4} ${openstack_compute_instance_v2.swarm-manager.name} ${element(openstack_compute_instance_v2.swarm-workers.*.access_ip_v4, count.index)} ${element(openstack_compute_instance_v2.swarm-workers.*.access_ip_v6, count.index)} ${element(openstack_compute_instance_v2.swarm-workers.*.name, count.index)}     ${var.floating_ip}"
  }
}
