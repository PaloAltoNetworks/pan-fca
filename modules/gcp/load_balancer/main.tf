resource "google_compute_global_address" "external-address" {
  count = "${var.lb_type == "internal" ? 0 : 1 }"
  name  = "${var.global_compute_address_name}"
}

resource "google_compute_instance_group" "fw-ig" {
  count = "${var.lb_type == "internal" ? 0 : 1 }"
  name  = "${var.instance_group_name}"

  instances = ["${var.instances}"]

  named_port {
    name = "http"
    port = "80"
  }
}

resource "google_compute_instance_group" "int-ig" {
  count = "${var.lb_type == "internal" ? 1 : 0 }"
  name  = "${var.instance_group_name}"

  instances = ["${var.instances}"]

  zone = "${var.region_zone}"
}

resource "google_compute_health_check" "health-check" {
  count = "${var.lb_type == "internal" ? 0 : 1 }"
  name  = "${var.elb_health_check_name}"

  http_health_check {}
}

resource "google_compute_backend_service" "fw-backend" {
  count    = "${var.lb_type == "internal" ? 0 : 1 }"
  name     = "${var.elb_backend_name}"
  protocol = "${var.backend_protocol}"

  backend {
    group = "${google_compute_instance_group.fw-ig.self_link}"
  }

  health_checks = ["${google_compute_health_check.health-check.self_link}"]
}

resource "google_compute_url_map" "http-elb" {
  count           = "${var.lb_type == "internal" ? 0 : 1 }"
  name            = "${var.elb_url_map_name}"
  default_service = "${google_compute_backend_service.fw-backend.self_link}"
}

resource "google_compute_target_http_proxy" "http-lb-proxy" {
  count   = "${var.lb_type == "internal" ? 0 : 1 }"
  name    = "${var.elb_http_proxy_name}"
  url_map = "${google_compute_url_map.http-elb.self_link}"
}

resource "google_compute_global_forwarding_rule" "default" {
  count      = "${var.lb_type == "internal" ? 0 : 1 }"
  name       = "${var.global_fowarding_rule_name}"
  target     = "${google_compute_target_http_proxy.http-lb-proxy.self_link}"
  ip_address = "${google_compute_global_address.external-address.address}"
  port_range = "${var.global_forwarding_rule_port_range}"
}

resource "google_compute_health_check" "tcp-health-check" {
  count = "${var.lb_type == "internal" ? 1 : 0 }"
  name  = "${var.ilb_health_check_name}"

  tcp_health_check {
    port = "${var.ilb_tcp_hc_port}"
  }
}

resource "google_compute_region_backend_service" "int-lb" {
  count = "${var.lb_type == "internal" ? 1 : 0 }"
  name  = "${var.ilb_backend_name}"

  health_checks = [
    "${google_compute_health_check.tcp-health-check.self_link}",
  ]

  region = "${var.region}"

  backend {
    group = "${google_compute_instance_group.int-ig.self_link}"
  }
}

resource "google_compute_forwarding_rule" "lb-forwarding-rule" {
  count                 = "${var.lb_type == "internal" ? 1 : 0 }"
  name                  = "${var.region_forwarding_rule_name}"
  load_balancing_scheme = "INTERNAL"
  ports                 = ["${var.internal_ports}"]
  network               = "${var.network_self_link}"
  subnetwork            = "${var.subnetwork_self_link}"
  backend_service       = "${google_compute_region_backend_service.int-lb.self_link}"
}
