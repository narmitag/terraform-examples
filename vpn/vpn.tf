
// CERTIFICATES
resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
 
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name  = "${var.environment_name}.vpn.ca"
    organization = "demo"
  }

  validity_period_hours = 87500
  is_ca_certificate     = true
  allowed_uses = [
    "cert_signing",
    "crl_signing"
  ]
}

resource "aws_acm_certificate" "ca" {
  private_key      = tls_private_key.ca.private_key_pem
  certificate_body = tls_self_signed_cert.ca.cert_pem
}

resource "tls_private_key" "root" {
  algorithm = "RSA"
}

resource "tls_cert_request" "root" {
 
  private_key_pem = tls_private_key.root.private_key_pem

  subject {
    common_name  = "${var.environment_name}.vpn.client"
    organization = "demo"
  }
}

resource "tls_locally_signed_cert" "root" {
  cert_request_pem   = tls_cert_request.root.cert_request_pem
 
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth"
  ]
}

resource "aws_acm_certificate" "root" {
  private_key       = tls_private_key.root.private_key_pem
  certificate_body  = tls_locally_signed_cert.root.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem
}

resource "tls_private_key" "server" {
  algorithm = "RSA"
}

resource "tls_cert_request" "server" {
 
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name  = "${var.environment_name}.vpn.server"
    organization = "demo"
  }
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem   = tls_cert_request.server.cert_request_pem
 
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 87600

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth"
  ]
}

resource "aws_acm_certificate" "server" {
  private_key       = tls_private_key.server.private_key_pem
  certificate_body  = tls_locally_signed_cert.server.cert_pem
  certificate_chain = tls_self_signed_cert.ca.cert_pem
}

/// VPN ENDPOINT

resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "Client VPN"
  split_tunnel           = true
  server_certificate_arn = aws_acm_certificate.server.arn
  client_cidr_block      = "10.0.240.0/22"
  transport_protocol     = "tcp"
  self_service_portal = "enabled"
  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.root.arn
  }

  connection_log_options {
    enabled = false
  }

  tags = {
    Name = "${var.environment_name} Client_VPN"
  }
}

resource "aws_security_group" "vpn" {
  vpc_id = module.vpc.vpc_id
  name   = "vpn-clients"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming VPN Connection"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Incoming VPN Connection"
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "aws_ec2_client_vpn_network_association" "vpn" {
  count = length(module.vpc.private_subnets)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = module.vpc.private_subnets[count.index]
  security_groups        = [aws_security_group.vpn.id]
}

resource "aws_ec2_client_vpn_authorization_rule" "vpn" {
  count                  = length(module.vpc.private_subnets_cidr_blocks)
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = module.vpc.private_subnets_cidr_blocks[count.index]
  authorize_all_groups   = true
}

resource "aws_ssm_parameter" "cert" {
  name  = "${var.environment_name}_vpn_certificate"
  type  = "SecureString"
  value = tls_locally_signed_cert.root.cert_pem
}

resource "aws_ssm_parameter" "key" {
  name  = "${var.environment_name}_vpn_key"
  type  = "SecureString"
  value = tls_private_key.root.private_key_pem
}

resource "aws_ssm_parameter" "endpoint_id" {
  name  = "${var.environment_name}_vpn_endpoint_id"
  type  = "SecureString"
  value = aws_ec2_client_vpn_endpoint.vpn.id
}

data "aws_availability_zones" "available" {}