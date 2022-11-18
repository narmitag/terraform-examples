data "aws_vpc" "owner" {
  provider = aws.owner
  id       = var.owner_vpc_id
}
data "aws_vpc" "accepter" {
  provider = aws.accepter
  id       = var.accepter_vpc_id
}
data "aws_route_tables" "owner" {
  provider = aws.owner
  vpc_id   = var.owner_vpc_id
}
data "aws_route_tables" "accepter" {
  provider = aws.accepter
  vpc_id   = data.aws_vpc.accepter.id
}
locals {
  accepter_account_id = element(split(":", data.aws_vpc.accepter.arn), 4)
  owner_account_id    = element(split(":", data.aws_vpc.owner.arn), 4)
}
resource "aws_vpc_peering_connection" "owner" {
  provider      = aws.owner
  vpc_id        = var.owner_vpc_id
  peer_vpc_id   = data.aws_vpc.accepter.id
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
  count                     = length(data.aws_route_tables.owner.ids)
  route_table_id            = tolist(data.aws_route_tables.owner.ids)[count.index]
  destination_cidr_block    = data.aws_vpc.accepter.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.owner.id
}
resource "aws_route" "accepter" {
  provider                  = aws.accepter
  count                     = length(data.aws_route_tables.accepter.ids)
  route_table_id            = tolist(data.aws_route_tables.accepter.ids)[count.index]
  destination_cidr_block    = data.aws_vpc.owner.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.owner.id
} 