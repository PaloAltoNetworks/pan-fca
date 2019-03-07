variable "fw_key_name" {
  description = "name of key"
  default     = ""
}

variable "fw_key" {
  description = "stdout of public key"
  default     = ""
}

//variable "fw_priv_key_path" {
//  description = "SSH Private Key Full Path"
//  type        = "string"
//  default     = ""
//}
//
//variable "username" {
//  description = "FW Username"
//  default = "admin"
//}
//
//variable "password" {
//  description = "FW Password"
//  default = ""
//}
//
//variable "go_path" {
//  description = "Path to execute GO Initalization binary"
//  default = ""
//}