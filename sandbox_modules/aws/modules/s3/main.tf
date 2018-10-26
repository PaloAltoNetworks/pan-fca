resource "aws_s3_bucket_object" "folder1" {
    bucket = "${aws_s3_bucket.b.id}"
    acl    = "private"
    key    = "Folder1/"
    source = "/dev/null"
}