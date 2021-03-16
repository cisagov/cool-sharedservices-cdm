# ------------------------------------------------------------------------------
# Associate the TGW VPN attachment to a non-default route table that
# allows communication to the Shared Services account but nowhere
# else.  This serves to isolate the CDM VPN tunnel from other
# accounts.
# ------------------------------------------------------------------------------

resource "aws_ec2_transit_gateway_route_table" "cdm" {
  provider = aws.sharedservicesprovisionaccount

  tags = merge(
    var.tags,
    {
      "Name" = "CDM s2s VPN route table"
    },
  )
  transit_gateway_id = data.terraform_remote_state.networking.outputs.transit_gateway.id
}

# Add a route to Shared Services to the route table
resource "aws_ec2_transit_gateway_route" "cdm_sharedservices" {
  provider = aws.sharedservicesprovisionaccount

  destination_cidr_block         = data.terraform_remote_state.networking.outputs.vpc.cidr_block
  transit_gateway_attachment_id  = data.terraform_remote_state.networking.outputs.transit_gateway_sharedservices_vpc_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.cdm.id
}

# Add a route to the VPN to the route table
resource "aws_ec2_transit_gateway_route" "cdm_vpn" {
  provider = aws.sharedservicesprovisionaccount

  destination_cidr_block         = var.cdm_cidr
  transit_gateway_attachment_id  = aws_vpn_connection.cdm.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.cdm.id
}

# Add a route to the VPN to the default route table used by the other
# resources in the Shared Services account
resource "aws_ec2_transit_gateway_route" "sharedservices_vpn" {
  provider = aws.sharedservicesprovisionaccount

  destination_cidr_block         = var.cdm_cidr
  transit_gateway_attachment_id  = aws_vpn_connection.cdm.transit_gateway_attachment_id
  transit_gateway_route_table_id = data.terraform_remote_state.networking.outputs.transit_gateway.association_default_route_table_id
}

# Break the association between the transit gateway attachment and the
# default transit gateway route table.
#
# It would be nice not to have to use the Terraform escape hatch for
# this, but if I don't do this first then I get "error associating EC2
# Transit Gateway Route Table (tgw-rtb-<id>) association
# (tgw-attach-<id>): Resource.AlreadyAssociated: Transit Gateway
# Attachment tgw-attach-<id> is already associated to a route table."
resource "null_resource" "break_association_with_default_route_table" {
  # Require that the transit gateway attachment is created before
  # breaking the association.
  depends_on = [
    aws_vpn_connection.cdm,
  ]

  provisioner "local-exec" {
    when = create
    # This command asks AWS to disassociate the default route table
    # from our transit gateway attachment, then loops until the
    # disassociation is complete.
    command = "aws --profile cool-sharedservices-provisionaccount --region ${var.aws_region} ec2 disassociate-transit-gateway-route-table --transit-gateway-route-table-id ${data.terraform_remote_state.networking.outputs.transit_gateway.association_default_route_table_id} --transit-gateway-attachment-id ${aws_vpn_connection.cdm.transit_gateway_attachment_id} && while aws --profile cool-sharedservices-provisionaccount --region ${var.aws_region} ec2 get-transit-gateway-route-table-associations --transit-gateway-route-table-id ${data.terraform_remote_state.networking.outputs.transit_gateway.association_default_route_table_id} | grep --quiet ${aws_vpn_connection.cdm.id}; do sleep 5s; done"
  }

  triggers = {
    tgw_default_route_table_id = data.terraform_remote_state.networking.outputs.transit_gateway.association_default_route_table_id
    tgw_vpc_attachment_id      = aws_vpn_connection.cdm.transit_gateway_attachment_id
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "cdm" {
  depends_on = [
    null_resource.break_association_with_default_route_table,
  ]
  provider = aws.sharedservicesprovisionaccount

  transit_gateway_attachment_id  = aws_vpn_connection.cdm.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.cdm.id
}
