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
    ssh_keys = [
      file(var.fullpath_ssh_fingerprint_file)
    ]

    # # connection to use for provisionning
    # connection {
    #       user = var.server_root_name
    #       type = "ssh"
    #       private_key = file(var.fullpath_priv_key_file)
    #       timeout = "2m"
    #       host    = digitalocean_droplet.hdGuild-jenkins.ipv4_address
    #   }

    # # initial setup for ubuntu install
    # provisioner "remote-exec" {
    #   script = var.initial_server_setup_script
    # }
    
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


resource "digitalocean_domain" "jenkinsSrv" {
    name = var.jenkinsDomainName
}

resource "digitalocean_record" "jenkinsSrv" {
    name = var.jenkinsServerName
    type = "A"
    domain = digitalocean_domain.jenkinsSrv.name
    value = digitalocean_droplet.hdGuild_jenkins.ipv4_address
}

resource "digitalocean_firewall" "jenkins" {
    name = var.jenkinsFirewallName
    droplet_ids = [digitalocean_droplet.hdGuild_jenkins.id]

    inbound_rule {
            protocol = "tcp"
            port_range = "22"
        }

    inbound_rule {
            protocol = "tcp"
            port_range = "80"
        }

    inbound_rule {
            protocol = "tcp"
            port_range = "443"
        }

    inbound_rule {
            protocol = "tcp"
            port_range = "8080"
        }

}

