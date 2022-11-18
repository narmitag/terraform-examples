resource "aws_s3_bucket" "assets" {
    bucket = "nats-assets-${random_id.random-seed.dec}"
    acl = "private"

}

resource "random_id" "random-seed" {
    byte_length = 8
}

resource "aws_s3_bucket_object" "dist" {
  for_each = fileset("assets/", "*")

  bucket = aws_s3_bucket.assets.id
  key    = each.value
  source = "assets/${each.value}"
  etag   = filemd5("assets/${each.value}")
}