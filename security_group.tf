# Security group for instances that run VENOM agents (Tainium and
# Tenable)
resource "aws_security_group" "venom" {
  provider = aws.sharedservicesprovisionaccount

  vpc_id = data.terraform_remote_state.networking.outputs.vpc.id

  description = "VENOM"
  tags = merge(
    var.tags,
    {
      "Name" = "VENOM"
    },
  )
}

# Egress rules
# resource "aws_security_group_rule" "client_egress" {
#   for_each = local.ipa_ports

#   security_group_id        = aws_security_group.client.id
#   type                     = "egress"
#   protocol                 = each.value.proto
#   source_security_group_id = aws_security_group.server.id
#   from_port                = each.value.port
#   to_port                  = each.value.port
# }
