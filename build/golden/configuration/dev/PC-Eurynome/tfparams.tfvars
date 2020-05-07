# security inpût variables for terraform
# personnal access token "HDGuild_Terraform2DigitalOcean" : value setted in keepass on dropbox


# fullpath for pat and security files that stay on workstation 
fullpath_do_token_file = "C:\\users\\Philippe\\.pat\\hdguild2do.token"  # PAT replace passwords -> used for provider.tf connection
fullpath_pub_key_file  = "C:\\users\\Philippe\\.ssh\\id_rsa"
fullpath_priv_key_file = "C:\\Users\\Philippe\\.ssh\\id_rsa.ppk"
fullpath_ssh_fingerprint_file = "C:\\users\\Philippe\\.ssh\\id_rsa.fingerprint"

# generic variables 
region = "FRA1"
environment = "development"
connectionType = "ssh" # winrm on windows \\ ssh on linux
ssh_key_id = "27305903" #PC_Eurynome_id_rsa on Digital Ocean

server_name = "hdGuild-jenkins"
# vm to deploy : ubuntu 18.04 server
# server_image = "ubuntu-18-04-x64" #slug
# initial_server_setup_script = "..\\scripts\\initial_ubuntu_server_setup.sh"

# vm to deploy : centos-7-x64 server
server_image = "centos-7-x64" #slug
initial_server_setup_script = "..\\scripts\\initial_centos_server_setup.sh"

server_size = "s-1vcpu-1gb" # minimal configuration - enought for tests
#server_host_url = "jenkins.helldorado.fr"

## connection to use for provisioning
server_root_name = "root"
jenkinsDomainName = "helldorado.fr"
jenkinsServerName = "jenkins"
jenkinsFirewallName = "firewall-jenkins"