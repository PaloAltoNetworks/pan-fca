variable "name" {}
variable "location" {}
variable "project" {}

variable "storage_class" {
  description = "REGIONAL,NEARLINE,COLDLINE,MULTI_REGIONAL"
  default = "MULTI_REGIONAL"
}

variable "iam_group" {
  description = "Group to associate with bucket"
}

variable "directories" {
  type = "list"
  default = ["config","content","license","software"]
}

variable "files" {
  type = "list"
}

variable "file_names" {
  type = "list"
}