module "install_linkerd" {
  source = "./terraform-helm-linkerd"

  # required values
  chart_version               = "2.11.1"
  ca_cert_expiration_hours    = 8760  # 1 year
  trust_anchor_validity_hours = 17520 # 2 years
  issuer_validity_hours       = 8760  # 1 year (must be shorter than the trusted anchor)
  depends_on = [
    helm_release.cert_manager,
  ]
}