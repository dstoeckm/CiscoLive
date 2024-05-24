// receive IP address based on DNS name needed for annotation in main.tf
data "dns_a_record_set" "rds" {
  host = aws_db_instance.opencart.address
}

output "rds_addrs" {
  value = join(",", data.dns_a_record_set.rds.addrs)
}
// write annotations for the RDS servcie into "User uploaded labels"
resource "tetration_tag" "tag01" {
  tenant_name = "dstoeckm"
  ip          = join(",", data.dns_a_record_set.rds.addrs)
  attributes = {
    Stage        = "prod"
    Datacenter   = "aws"
    VPC-ID       = "vpc-079c23af1c7563512"
    app_name     = "opencart"
    Scope        = "application"
    Database     = "AWS-RDS"
    location     = "eu-central-1"
    Access_group = "RDS_access"
  }
}
// write annotations for the TGWservcie into "User uploaded labels"
resource "tetration_tag" "tag02" {
  tenant_name = "dstoeckm"
  ip          = "172.31.31.174"
  attributes = {
    Datacenter = "aws"
    app_name   = "opencart"
    tgw-ID     = "eni-017d25c72fb8d68c7"
    location   = "eu-central-1"
    VPC-ID     = "vpc-079c23af1c7563512"
  }
}
