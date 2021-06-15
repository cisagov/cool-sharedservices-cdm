# A new, CDM-enhanced set of DHCP options for instances that run in
# the Shared Services VPC.
#
# For the Tenable CDM agent to function it has to be able to look up
# the CDM Tenable server in DNS using only the first segment of its
# hostname; therefore, we have to add the "main" CDM domain as an
# additional search domain.
resource "aws_vpc_dhcp_options" "cdm" {
  provider = aws.sharedservicesprovisionaccount

  # The first domain listed is the main domain
  domain_name          = format("%s %s", data.terraform_remote_state.networking.outputs.vpc_dhcp_options.domain_name, var.cdm_domains[0])
  domain_name_servers  = data.terraform_remote_state.networking.outputs.vpc_dhcp_options.domain_name_servers
  netbios_name_servers = data.terraform_remote_state.networking.outputs.vpc_dhcp_options.netbios_name_servers
  netbios_node_type    = data.terraform_remote_state.networking.outputs.vpc_dhcp_options.netbios_node_type
  ntp_servers          = data.terraform_remote_state.networking.outputs.vpc_dhcp_options.ntp_servers
  tags = {
    Name = "CDM"
  }
}

# Associate the DHCP options with the Shared Services VPC
resource "aws_vpc_dhcp_options_association" "cdm" {
  provider = aws.sharedservicesprovisionaccount

  dhcp_options_id = aws_vpc_dhcp_options.cdm.id
  vpc_id          = data.terraform_remote_state.networking.outputs.vpc.id
}
