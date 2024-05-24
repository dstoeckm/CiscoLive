// Building AWS EC2 instance "web-tier"
resource "aws_instance" "web-tier" {
  ami                         = "ami-030e490c34394591b"
  availability_zone           = "eu-central-1c"
  private_ip                  = "172.31.7.247"
  associate_public_ip_address = false
  ebs_optimized               = false
  instance_type               = "t2.micro"
  monitoring                  = false
  key_name                    = "terraform-mcd-key"

  tags = {
    Name         = "opencart-web-front"
    app_name     = "opencart"
    Stage        = "prod"
    Compliance   = "PCI"
    owner        = "dstoeckm"
    Tier         = "web-tier"
    Scope        = "application"
    Access_group = "RDS_access"
  }
}
// Building AWS EC2 instance "rouge-instance"
// resource "aws_instance" "rogue-instance" {
//   ami               = "ami-030e490c34394591b"
//   availability_zone = "eu-central-1c"
//   private_ip        = "172.31.1.228"
//   ebs_optimized     = false
//   instance_type     = "t2.micro"
//   monitoring        = false
//   key_name          = "terraform-mcd-key"
//   provisioner "local-exec" {
//     command = "sudo /usr/sbin/sshd -p 822"
//   }
// 
//   tags = {
//     Name         = "rogue"
//     Stage        = "dev"
//     Compliance   = ""
//     owner        = "dstoeckm"
//     Tier         = "rogue-instance"
//     Scope        = "application"
//     Access_group = "RDS_access"
//   }
// }

// Building AWS RDS "AWS-RDS" >> this can't be tagged here so the tetration.tf is doing this <<
resource "aws_db_instance" "opencart" {
  allocated_storage      = 20
  engine                 = "mariadb"
  engine_version         = "10.11.6"
  instance_class         = "db.m5.large"
  name                   = "opencart"
  username               = var.db_user
  password               = var.db_password
  port                   = "3306"
  storage_encrypted      = true
  # parameter_group_name   = "default.mariadb10.5"
  skip_final_snapshot    = true
  # vpc_security_group_ids = [aws_security_group.rds.id]
  # vpc_security_group_ids = ["${aws_security_group.web-tier.id}"]

  tags = {
    Environment  = "demo"
    Datacenter   = "aws"
    owner        = "dstoeckm"
    app_name     = "opencart"
    Database     = "AWS-RDS"
    Scope        = "application"
    location     = "eu-central-1"
    Access_group = "RDS_access"
  }
}


// secureity group to access RDS
resource "aws_security_group" "rds" {
  name = "RDS_access"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/20"]
  }
  tags = {
    owner = "dstoeckm"
    Name  = "RDS_Access"
  }
}

## resource "aws_vpc" "opencart_vpc" {
##   # (resource arguments)
##   tags = {
##     Name = "opencart_vpc"
##   }
## }