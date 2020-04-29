# data file to be red for security content
# security inpût variables for terraform
# personnal access token "HDGuild_Terraform2DigitalOcean" = value setted in keepass on dropbox


# Local section to import tags on all resources
locals {
    myProject         = "jenkinsServerOnDO"
    mySCM             = "GitHub"
    myProvider        = "digitalocean"
    myDeployment      = "terraform"
    myEnvironment     = "FRA1"
}

locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Project         = local.myProject
    SCM             = local.mySCM        
    Provider        = local.myProvider   
    Deployment      = local.myDeployment 
    Environment     = local.myEnvironment
  }
}


# creates the droplet on Digital Ocean 
resource "digitalocean_droplet" "hdGuild_jenkins" {
    # generic data
    #tags = local.common_tags
    # vm to deploy
    image = var.server_image
    name = var.server_name
    region = var.region
    size = var.server_size
    ipv6 = true
    private_networking = true
    #ssh key Id from DigitalOcean ssh public key to create new droplet
    # the public ssh key corresponding to the id will be added to the droplet !
    ssh_keys = [var.ssh_key_id]


    # connection to use for provisionning
    connection {
        user = var.server_root_name
        type = var.connectionType
        # no need of private key as the agent as loaded the ssh private key
        #private_key = file(var.fullpath_priv_key_file)
        agent = true
        timeout = "2m"
        host = self.ipv4_address
    }
    # initial setup for ubuntu install
    provisioner "remote-exec" {
        script = var.initial_server_setup_script
    }
    
    # # install ngninx server
    # provisioner "remote-exec" {
    #   inline = [
    #     "export PATH=$PATH=/usr/bin",
    #     # install nginx
    #     "sudo apt-get update",
    #     "sudo apt-get -y install nginx"
    #   ]
    # }
}

## no more domain actually.
# resource "digitalocean_domain" "jenkinsSrv" {
#     name = var.jenkinsDomainName
# }

# resource "digitalocean_record" "jenkinsSrv" {
#     name = var.jenkinsServerName
#     type = "A"
#     domain = digitalocean_domain.jenkinsSrv.name
#     value = digitalocean_droplet.hdGuild_jenkins.ipv4_address
# }

# #Firewall rules blocs ssh access
# resource "digitalocean_firewall" "jenkins" {
#     name = var.jenkinsFirewallName
#     droplet_ids = [digitalocean_droplet.hdGuild_jenkins.id]

#     inbound_rule {
#             protocol = "tcp"
#             port_range = "22"
#             source_addresses  = ["all"]
#         }

#     inbound_rule {
#             protocol = "tcp"
#             port_range = "80"
#             source_addresses  = ["all"]
#         }

#     inbound_rule {
#             protocol = "tcp"
#             port_range = "443"
#             source_addresses  = ["all"]
#         }

#     inbound_rule {
#             protocol = "tcp"
#             port_range = "8080"
#         }

# }

