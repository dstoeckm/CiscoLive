// Variables //
variable "cisco_mcd_ingress_GWE" {
  description = "Ingress Gateway Endpoint"
  #  sensitive   = true
   default = "ciscomcd-l-ingrirsimxhx-48d6ad38b3e4e8c2.elb.eu-central-1.amazonaws.com"
  ## default = "brksec-2421.dus.ciscolabs.com"
}
variable "cisco_mcd_egress_proxy_ip" {
  description = "Egress Gateway proxy IP"
  #  sensitive   = true
  default = "10.1.1.65"
}
variable "aws_access_key_id" {
  description = "AWS Access Key"
  #  sensitive   = true
  default = {}
}
variable "db_password" {
  description = "MariaDB password"
    sensitive   = true
  default = {}
}
variable "db_user" {
  description = "MariaDB user"
    sensitive   = true
  default = {}
}
variable "aws_secret_access_key" {
  description = "AWS Secret Key"
  #  sensitive   = true
  default = {}
}
variable "region" {
  description = "AWS Region ex: eu-central-1"
  default     = {}
}
variable "vpc_name" {
  description = "VPC Name"
  default     = "csw_emear_tsa"
}
variable "deployment_name" {
  description = "Name of the deployment"
  default     = "dstoeckm"
}
variable "profile" {
  description = "aws cli profile"
  default     = {}
}
variable "vpc_flow_log_tags" {
  description = "Additional tags for the VPC Flow Logs"
  type        = map(string)
  default     = {}
}
variable "flow_log_log_format" {
  description = "The fields to include in the flow log record, in the order in which they should appear."
  type        = string
  default     = null
}
variable "aws_security_group" {
  description = "aws_security_group to be attached to RDS"
  type        = map(string)
  default     = {}
}
#variable "private_ip" {
#  description = "The private IP address assigned to the instance."
#  type        = string
#} 
#
#variable "public_ip" {
#  description = "The public IP address assigned to the instance, if applicable. NOTE: If you are using an aws_eip with your instance, you should refer to the EIP's address directly and not use `public_ip` as this field will change after the EIP is attached"
#  type        = string
#}
#variable "db_instance_address" {
#  description = "The address of the RDS instance"
#  type        = string
#}
#variable "db_instance_availability_zone" {
#  description = "The availability zone of the RDS instance"
#  type        = string
#}