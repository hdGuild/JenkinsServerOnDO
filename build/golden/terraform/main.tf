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
    # initial setup for server install
    # Do not forgot to add the key to ssh agent before this step !!
    provisioner "remote-exec" {
        scripts = [var.initial_server_setup_script,
                   var.jenkins_install_script,
                   var.jenkins_init_script,
                   var.ansible_install_script]
    }
    
}

resource "digitalocean_floating_ip_assignment" "jenkins_floatingip_assign" {
  ip_address = var.floating_ip
  droplet_id = digitalocean_droplet.hdGuild_jenkins.id
}
