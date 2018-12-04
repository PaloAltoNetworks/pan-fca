
variable "region" {
    description = "AWS region"
    default = "us-east-1"
}

variable "s3_folders" {
  type        = "list"
  description = "The list of S3 folders to create"
  default     = ["config", "content", "license","software"]
}