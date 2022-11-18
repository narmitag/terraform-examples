

#Left here for reference to share to another account 
#needs the variable clients populated with valid account numbers

# resource "aws_ram_resource_share" "ram" {
#   name                      = "TGW Ram Share"
#   allow_external_principals = true
# }

# resource "aws_ram_principal_association" "ram" {
#   for_each = toset(var.clients)
#   principal          = each.value
#   resource_share_arn = aws_ram_resource_share.ram.id
# }

# resource "aws_ram_resource_association" "ram" {
#   resource_arn       = aws_ec2_transit_gateway.demo_tgw.arn
#   resource_share_arn = aws_ram_resource_share.ram.id
# }
