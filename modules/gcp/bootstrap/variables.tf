variable bucket_name {}

variable file_location {}

variable config {
  type    = "list"
  default = []
}

variable content {
  type    = "list"
  default = []
}

variable license {
  type    = "list"
  default = []
}

variable software {
  type    = "list"
  default = []
}

variable randomize_bucket_name {
  default = false
}
