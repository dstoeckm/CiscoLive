// output variables to be used in the setup

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.web-tier.public_ip
}
output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.opencart.address
  sensitive   = false
}