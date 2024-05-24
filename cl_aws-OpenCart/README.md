**Cisco MultiCloud Defense**

this repo is to demo OpenCart on AWS for a Cisco Mulitcloud Defense setup
You need to fill out the necessary information in provider.tf
 also, you want to define in the variable.TF file the **cisco_mcd_ingress_GWE** default config. This is where your SSH servers is pointing to the PrivatIP of the AWS instance. 

you need to define var ina file called terraform.tfvars in the form of:
# aws.tfvars
db_password = "your_secret_password"
db_user     = "your_user"


Upgradeing to AMZ Linux 2023 and /usr/bin/python 
