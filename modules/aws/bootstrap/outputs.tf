output "bootstrap_bucket_id" {
  value = "${aws_s3_bucket.bootstrap_bucket.id}"
}

output "bootstrap_bucket_name" {
  value = "${aws_s3_bucket.bootstrap_bucket.bucket}"
}