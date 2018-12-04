output "folders_created" {
  description = "List of firewalls created"
  value = "${zipmap(
      aws_s3_bucket.palobuckettest123.*.id,
      var.s3_folders)}"
}