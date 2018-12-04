
resource "aws_s3_bucket" "palobuckettest123" {
  bucket = "palobucket1234"
  acl    = "private"
}


resource "aws_s3_bucket_object" "palo" {
    count   = "${length(var.s3_folders)}"
    bucket = "${aws_s3_bucket.palobuckettest123.id}"
    acl    = "private"
    key    = "${var.s3_folders[count.index]}/"
    source = "/dev/null"
}