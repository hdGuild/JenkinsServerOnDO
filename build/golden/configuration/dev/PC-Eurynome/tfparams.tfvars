# security inpût variables for terraform
# personnal access token "HDGuild_Terraform2DigitalOcean" : value setted in keepass on dropbox

# fullpath for pat and security files that stay on workstation 
fullpath_do_token_file = "C:/users/Philippe/.pat/hdguild2do.token"  # PAT replace passwords -> used for provider.tf connection
fullpath_pub_key_file  = "C:/users/Philippe/.ssh/DO_id_rsa.pub"
fullpath_priv_key_file = "C:/users/Philippe/.ssh/DO_id_rsa"
fullpath_ssh_fingerprint_file = "C:/users/Philippe/.ssh/DO_id_rsa.fingerprint"

# generic variables 
region = "FRA1"

# ubuntu 18.04 server
server_name = "hdGuild-jenkins"
server_image = "ubuntu-18-04-x64"
server_size = "2Gb"
#server_host_url = "jenkins.helldorado.fr"
initial_server_setup_script = "..\\scripts\\initial_server_setup.sh"

## connection to use for provisioning
server_root_name = "root"