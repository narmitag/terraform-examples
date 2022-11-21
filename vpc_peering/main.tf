locals {
  accepter_account_id = data.aws_caller_identity.accepter.account_id
  owner_account_id    = data.aws_caller_identity.owner.account_id
}

resource "aws_vpc_peering_connection" "owner" {
  provider      = aws.owner
  vpc_id        = module.vpc-owner.vpc_id
  peer_vpc_id   = module.vpc-accepter.vpc_id
  peer_owner_id = local.accepter_account_id
  peer_region   = "us-east-1"
  tags = {
    Name = "peer_to_accepter"
  }
}
resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider                  = aws.accepter
  vpc_peering_connection_id = aws_vpc_peering_connection.owner.id
  auto_accept               = true
  tags = {
    Name = "peer_to_owner"
  }
}
resource "aws_route" "owner" {
  provider                  = aws.owner
  count                     = length(concat(module.vpc-owner.private_route_table_ids,module.vpc-owner.public_route_table_ids))
  route_table_id            = concat(module.vpc-owner.private_route_table_ids,module.vpc-owner.public_route_table_ids)[count.index]
  destination_cidr_block    = module.vpc-accepter.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.owner.id
  depends_on = [
    module.vpc-owner
  ]
}
resource "aws_route" "accepter" {
  provider                  = aws.accepter
  count                     = length(concat(module.vpc-accepter.private_route_table_ids,module.vpc-accepter.public_route_table_ids))
  route_table_id            = concat(module.vpc-accepter.private_route_table_ids,module.vpc-accepter.public_route_table_ids)[count.index]
  destination_cidr_block    = module.vpc-owner.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.owner.id
  depends_on = [
    module.vpc-accepter
  ]
} 