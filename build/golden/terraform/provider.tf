# provider digitalocean to use with hdguild account

provider "digitalocean" {
  token = file(var.fullpath_do_token_file)
}