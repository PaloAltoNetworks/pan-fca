variable "global_compute_address_name" {
  description = "Global Address Name for GLB"
  default     = ""
}

variable "instance_group_name" {
  description = "Firewall Instance Group Name for Load Balancer"
  default     = ""
}

variable "instances" {
  description = "GCP Instances"
  type        = "list"
}

variable "elb_health_check_name" {
  description = "GLB Health Check Name"
  default     = ""
}

variable "elb_backend_name" {
  description = "GLB Backend Name"
  default     = ""
}

variable "backend_protocol" {
  description = "GLB Backend Protocol"
  default     = ""
}

variable "elb_url_map_name" {
  description = "GLB URL Map Name"
  default     = ""
}

variable "elb_http_proxy_name" {
  description = "GLB Http Proxy Name"
  default     = ""
}

variable "global_fowarding_rule_name" {
  description = "GLB Forwarding Rule"
  default     = ""
}

variable "global_forwarding_rule_port_range" {
  description = "Forwarding rule port range"
  default     = "80"
}

variable "lb_type" {
  description = "public or internal"
  default     = "public"
}

variable "region_forwarding_rule_name" {
  description = "Regaionl Forwarding Rule Name"
  default     = ""
}

variable "region_zone" {
  description = "GCP Regional Zone Name"
  default     = ""
}

variable "internal_ports" {
  description = "ILB Ports to load balance"
  type        = "list"
  default     = [""]
}

variable "network_self_link" {
  description = "Self Link for GCP Network"
  default     = ""
}

variable "subnetwork_self_link" {
  description = "Self Link for GCP Subnetwork"
  default     = ""
}

variable "ilb_backend_name" {
  description = "ILB Backend Service Name"
  type        = "string"
  default     = ""
}

variable "ilb_health_check_name" {
  description = "ILB Health Check Name"
  default     = ""
}

variable "ilb_tcp_hc_port" {
  description = "ILB TCP Healthcheck Port"
  default     = "80"
}

variable "region" {
  type    = "string"
  default = ""
}
