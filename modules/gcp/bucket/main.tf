resource "google_storage_bucket" "bootstrap" {
  name          = "${var.name}"
  location      = "${var.location}"
  project       = "${var.project}"
  storage_class = "${var.storage_class}"
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = "${google_storage_bucket.bootstrap.name}"
  role   = "roles/storage.objectViewer"

  members = [
    "user:${var.iam_group}",
  ]
}

resource "google_storage_bucket_object" "directory" {
  count   = "${length(var.directories)}"
  bucket  = "${google_storage_bucket.bootstrap.name}"
  name    = "${element(var.directories,count.index)}/"
  content = "I'm creating a folder."
}

resource "google_storage_bucket_object" "files" {
  count  = "${length(var.files)}"
  bucket = "${google_storage_bucket.bootstrap.name}"
  name   = "${element(var.directories,count.index)}/${element(var.file_names,count.index)}"
  source = "${element(var.files,count.index)}"
  depends_on = ["google_storage_bucket_object.directory"]
}
