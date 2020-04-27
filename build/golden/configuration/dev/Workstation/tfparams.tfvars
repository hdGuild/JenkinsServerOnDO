# security inpût variables for terraform
# personnal access token "HDGuild_Terraform2DigitalOcean" : value setted in keepass on dropbox

# fullpath for pat and security files that stay on workstation 
fullpath_do_token_file = "C:/users/pcarpentier/.pat/IngenicoWorkStation2DO.token" # PAT prevent the use of password -> used for provider.tf connection
# generated using CMD\ssh_keygen command.
# rem : puttygen does not generate good ssh format for DigitalOcean use.
fullpath_pub_key_file = "C:/Users/pcarpentier/.ssh/do_id_rsa.pub"
fullpath_priv_key_file = "C:/Users/pcarpentier/.ssh/do_id_rsa"
# the fingerprint generated by ssh-keygen is not at good format : take the fingerprint generated by DigitalOcean for use.
fullpath_ssh_fingerprint_file = "C:/Users/pcarpentier/.ssh/do_id_rsa.fingerprint"

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