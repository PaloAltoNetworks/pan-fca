
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

##########################################
#### Create an S3 endpoint in the VPC ####
##########################################
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.palo.id}"
  service_name = "com.amazonaws.${var.region}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "rtpalos3" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
  route_table_id  = "${aws_route_table.untrust_subnet.id}"
}
