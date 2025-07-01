module "vpc" {
  source = "git::https://github.com/harshatejaadduri/terraform-vpc.git?ref=main"
  project = var.project
  environment = var.environment
  public_cidr_block  = var.public_subnet
  private_cidr_block = var.private_subnet
  database_cidr_block = var.database_subnet
  
  is_peering_requried = true

}