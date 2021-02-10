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

resource "aws_security_group_rule" "venom" {
  for_each = local.venom_ports
  provider = aws.sharedservicesprovisionaccount

  security_group_id = aws_security_group.venom.id
  type              = each.value.egress ? "egress" : "ingress"
  prefix_list_ids   = [aws_ec2_managed_prefix_list.venom.id]
  protocol          = each.value.proto
  from_port         = each.value.port
  to_port           = each.value.port
}
