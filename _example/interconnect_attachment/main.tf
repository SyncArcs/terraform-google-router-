provider "google" {
  project = "testing-gcp-syn"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

####==============================================================================
#### vpc module call.
####==============================================================================
module "vpc" {
  source                                    = "git::https://github.com/SyncArcs/terraform-google-vpc.git?ref=master"
  name                                      = "dev1"
  environment                               = "test"
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}

####==============================================================================
#### interconnect_attachment module call.
####==============================================================================
module "cloud_router" {
  source                          = "../../"
  name                            = "dev1"
  environment                     = "test"
  region                          = "asia-northeast1"
  network                         = module.vpc.vpc_id
  enabled_interconnect_attachment = true
  #  interconnect = "https://googleapis.com/interconnects/example-interconnect"

  bgp = {
    asn               = "16550"
    advertised_groups = ["ALL_SUBNETS"]
  }
}