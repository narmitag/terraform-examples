resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

#tfsec:ignore:aws-iam-no-policy-wildcards
resource "aws_iam_policy" "cert_manager_policy" {
  name        = "${local.cluster_name}-cert-manager-policy"
  path        = "/"
  description = "Policy, which allows CertManager to create Route53 records"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "route53:GetChange",
        "Resource" : "arn:aws:route53:::change/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : "arn:aws:route53:::hostedzone/*"
      },
    ]
  })
}

module "cert_manager_iam_oidc" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> 4.0"
  create_role                   = true
  role_name                     = "${local.cluster_name}-cert-manager"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cert_manager_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:cert-manager:cert-manager"]
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  namespace  = "cert-manager"
  version    = var.cert_manager_version
  depends_on = [
    kubernetes_namespace.cert_manager,
  ]
  values = [templatefile("${path.module}/yaml/cert-manager.yaml", {
    arn = "${module.cert_manager_iam_oidc.iam_role_arn}"
  })]
}

output "certmanager_role_arn" {
  value = module.cert_manager_iam_oidc.iam_role_arn
}


data "kubectl_path_documents" "cert" {
  pattern = "${path.module}/yaml/cert.yaml"
}

# resource "kubectl_manifest" "cert" {
#   count     = length(data.kubectl_path_documents.cert.documents)
#   yaml_body = element(data.kubectl_path_documents.cert.documents, count.index)
# }