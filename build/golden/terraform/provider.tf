# provider digitalocean to use with hdguild account

provider "digitalocean" {
  token = file(var.fullpath_do_token_file)
  version = "~> 1.0"
}

# Waiting for terrafomr backend to store tfstate file
terraform {
  backend "s3" {
    endpoint = "ams3.digitaloceanspaces.com"
    region = "eu-central-1"
    bucket = "hdguildspace"
    key = "tfstate/jenkins-srv.tfstate"
    access_key = "LXCT7DI4XEB6FKV5FMFG"
    #secret_key = file("C:\\Users\\Philippe\\.sak\\HDGuild_tfstate.secret") 
    # call the terraform init with the following parameter to set the secret :
    ## terraform init -backend-config="secret_key=<HDGuild_tfstate.secret content>"   
    skip_requesting_account_id = true
    skip_credentials_validation = true
    skip_get_ec2_platforms = true
    skip_metadata_api_check = true
  }
}