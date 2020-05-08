# fullpath for pat and ssh security files that stay on workstation 
variable "fullpath_do_token_file" {}
variable "fullpath_pub_key_file" {}
variable "fullpath_priv_key_file" {}
variable "fullpath_ssh_fingerprint_file" {}

# generic variables
variable "region" {}
variable "environment" {}
variable "connectionType" {}
variable "ssh_key_id" {}

# variable for jenkins server install
variable "server_image" {}
variable "server_name" {}
variable "server_size" {}
variable "initial_server_setup_script" {}
#variable "server_host_url" {}
## connection to use for provisioning
variable "server_root_name" {}
variable "jenkinsDomainName" {}
variable "jenkinsServerName" {}
variable "jenkinsFirewallName" {}
