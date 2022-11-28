
resource "aws_s3_bucket" "velero" {
  bucket = "eks-velero-backup-${var.environment_name}-${random_id.random-seed.dec}"
  acl    = "private"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
  versioning {
    enabled = true
  }
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}

resource "aws_s3_bucket_policy" "velero" {
    bucket = aws_s3_bucket.velero.id

    policy = jsonencode({
        Version = "2012-10-17"
        Id      = "velero-${var.environment_name}-bucket-policy"
        Statement = [
            {
                Sid       = "EnforceTls"
                Effect    = "Deny"
                Principal = "*"
                Action    = "s3:*"
                Resource = [
                    "${aws_s3_bucket.velero.arn}/*",
                    "${aws_s3_bucket.velero.arn}",
                ]
                Condition = {
                    Bool = {
                        "aws:SecureTransport" = "false"
                    }
                    NumericLessThan = {
                        "s3:TlsVersion": 1.2
                    }
                }
            },
        ]
    })
}


module "velero" {
  source  = "DNXLabs/eks-velero/aws"
  version = "0.1.2"

  enabled = true

  cluster_name                     = module.eks.cluster_id
  cluster_identity_oidc_issuer     = module.eks.cluster_oidc_issuer_url
  cluster_identity_oidc_issuer_arn = module.eks.oidc_provider_arn
  aws_region                       = var.region
  create_bucket                    = false
  bucket_name                      = aws_s3_bucket.velero.bucket
  helm_chart_version               = "2.30.1"
}