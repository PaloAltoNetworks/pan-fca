
resource "google_compute_instance_group" "ig" {
  name = "${var.name}"
  instances = ["${var.instances}"]

  named_port {
    name = "${var.port_name}"
    port = "${var.port}"
  }
}