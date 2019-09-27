data "aws_caller_identity" "peer" {
  provider = aws.peer
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "requester" {
  count         = var.enabled == "true" ? 1 : 0
  vpc_id        = join("", data.aws_vpc.requester.*.id)
  peer_vpc_id   = join("", data.aws_vpc.accepter.*.id)
  peer_owner_id = data.aws_caller_identity.peer.account_id
  peer_region   = var.accepter_region
  auto_accept   = "false"
  tags          = var.requester_peer_tags
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = aws.peer
  count                     = var.enabled == "true" ? 1 : 0
  vpc_peering_connection_id = aws_vpc_peering_connection.requester[count.index].id
  auto_accept               = "true"
  tags                      = var.accepter_peer_tags
}

# Lookup requester VPC so that we can reference the CIDR
data "aws_vpc" "requester" {
  id = var.requester_vpc_id
}

# Lookup accepter VPC so that we can reference the CIDR
data "aws_vpc" "accepter" {
  provider = aws.peer
  id       = var.accepter_vpc_id
}

# Create routes from requester to accepter
resource "aws_route" "requester" {
  count = var.enabled == "true" ? 1 : 0
  route_table_id = data.aws_vpc.requester.main_route_table_id
  destination_cidr_block    = data.aws_vpc.accepter.cidr_block_associations[count.index % length(data.aws_vpc.accepter.*.cidr_block_associations)]["cidr_block"]
  vpc_peering_connection_id = aws_vpc_peering_connection.requester[count.index].id
  depends_on = [
    aws_vpc_peering_connection.requester,
  ]
}

# Create routes from accepter to requester
resource "aws_route" "accepter" {
  provider = aws.peer
  count    = var.enabled == "true" ? 1 : 0
  route_table_id = data.aws_vpc.accepter.main_route_table_id
  destination_cidr_block    = data.aws_vpc.requester.cidr_block_associations[count.index % length(data.aws_vpc.requester.*.cidr_block_associations)]["cidr_block"]
  vpc_peering_connection_id = aws_vpc_peering_connection.requester[count.index].id
  depends_on = [
    aws_vpc_peering_connection.requester
  ]
}
