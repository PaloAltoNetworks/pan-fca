terraform {
  #required_version = ">= 0.9.0"
}

data "aws_caller_identity" "current" {}

resource "aws_dynamodb_table" "tf_backend_state_lock_table" {
  count = "${var.dynamodb_lock_table_enabled ? 1 : 0}"
  name           = "${var.dynamodb_lock_table_name}"
  read_capacity  = "${var.lock_table_read_capacity}"
  write_capacity = "${var.lock_table_write_capacity}"
  hash_key       = "LockID"
  stream_enabled = "${var.dynamodb_lock_table_stream_enabled}"
  stream_view_type = "${var.dynamodb_lock_table_stream_enabled ? var.dynamodb_lock_table_stream_view_type : ""}"

  attribute {
    name = "LockID"
    type = "S"
  }
  tags {
    Description = "Terraform state locking table for account ${data.aws_caller_identity.current.account_id}."
    ManagedByTerraform = "true"
    TerraformModule = "terraform-aws-backend"
  }

  lifecycle {
    prevent_destroy = true
  }

}

resource "aws_s3_bucket" "tf_backend_bucket" {
  bucket = "${var.backend_bucket}"
  acl = "private"
  versioning {
    enabled = true
  }
  logging {
    target_bucket = "${aws_s3_bucket.tf_backend_logs_bucket.id}"
    target_prefix = "log/"
  }
  tags {
    Description = "Terraform S3 Backend bucket which stores the terraform state for account ${data.aws_caller_identity.current.account_id}."
    ManagedByTerraform = "true"
    TerraformModule = "terraform-aws-backend"
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "tf_backend_logs_bucket" {
  bucket = "${var.backend_bucket}-logs"
  acl = "log-delivery-write"
  versioning {
    enabled = true
  }
  tags {
    Purpose = "Logging bucket for ${var.backend_bucket}"
    ManagedByTerraform = "true"
    TerraformModule = "terraform-aws-backend"
  }
  lifecycle {
    prevent_destroy = true
  }
}
