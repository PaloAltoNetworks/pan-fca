resource "google_compute_instance_from_template" "instance" {
  count = "${var.nb_instances}"
  name  = "${element(var.instance_name,count.index)}"
  zone  = "${var.zone}"

  source_instance_template = "${google_compute_instance_template.tpl.self_link}"

  // Override fields from instance template
  can_ip_forward = "${var.ip_forwarding}"

  labels = {
    my_key = "my_value"
  }
}
