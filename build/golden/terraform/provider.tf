# provider digitalocean to use with hdguild account

provider "digitalocean" {
  token = file(var.fullpath_do_token_file)
  version = "~> 1.0"
}

terraform {
  backend "s3" {
    endpoint = "ams3.digitaloceanspaces.com"
    region = var.region
    key = "terraform.tfstate"
    skip_requesting_account_id = true
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_metadata_api_check = true
  }
}