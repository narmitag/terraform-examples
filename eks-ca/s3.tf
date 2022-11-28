resource "aws_s3_bucket" "log_bucket" {
  bucket = "s3-logging-${var.environment_name}-${random_id.random-seed.dec}"
  acl    = "log-delivery-write"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning {
    enabled = false
  }
  lifecycle_rule {
      id      = "log_retention"
      prefix  = "logs/"
      enabled = true

     expiration {
        days = 31
      }
  }

}

resource "random_id" "random-seed" {
    byte_length = 8
}