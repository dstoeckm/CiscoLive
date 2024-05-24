// Providers //
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    tetration = {
      source  = "CiscoDevNet/tetration"
      version = "0.1.1"
    }
  }
}
#// This is my local S3 to share terraform.tfstate >> uncommennd by # if you want that local to your setup <<
#terraform {
#  backend "s3" {
#    key = "terraform.tfstate"
#
#    endpoint = "http://10.49.166.36:9000"
#    
#    access_key="admin"
#    secret_key="DusLab123!"
#    
#    region = "duslab"
#    bucket = "tfbkp"
#    skip_credentials_validation = true
#    skip_metadata_api_check = true
#    skip_region_validation = true
#    force_path_style = true
#  }
#}

// Configure the AWS Provider
provider "aws" {
  region                  = "eu-central-1"
  shared_credentials_file = "/Users/dstoeckm/.aws/credentials" ### will be used for local aws credentials 
  profile                 = "dstoeckm-john"
}

# // Configure the tetration provider
### plx.cisco.com ###
# provider "tetration" {
#   api_key                  = "ad0d4b1b98f44622b8918ef9eede0ad8"
#   api_secret               = "981d54af8b7812a4d999c6c7e4958fc433f0e48a"
#   api_url                  = "https://10.49.166.4" #"https://plx.cisco.com"
# #  shared_credentials_file = "/Users/dstoeckm/.terraform.d/PLX-api_credentials.json" ### will be used for local CSW credentials 
#   disable_tls_verification = true
# }
### tet-pov-rtp1.cpoc.co ###
provider "tetration" {
  api_key                  = "495beb66d263448191ee952952e6ea97"
  api_secret               = "a40c879e38a89f1be8d652588439b8231d1d802e"
  api_url                  = "https://tet-pov-rtp1.cpoc.co" #"https://plx.cisco.com"
  disable_tls_verification = true
}