# data file to be red for security content
# security inpût variables for terraform
# personnal access token "HDGuild_Terraform2DigitalOcean" : value setted in keepass on dropbox


# Local section to import tags on all resources
locals {
  common_tags = {
    "GitHub project"      = "jenkinsServerOnDO"
    Provider              = "digitalocean"
    Deployment            = "terraform"
    Environment           = var.environment
  }
}

# creates the droplet on Digital Ocean 
resource "digitalocean_droplet" "hdGuild-jenkins" {
    # generic data
    tags = "${merge(local.common_tags)}"
    # vm to deploy
    image = var.server_image
    name = var.server_name
    region = var.region
    size = var.server_size
    private_networking = true
    ssh_keys = [
      file(var.fullpath_ssh_fingerprint_file)
    ]

    # connection to use for provisionning
    connection {
          user = var.server_root_name
          type = "ssh"
          private_key = file(var.fullpath_priv_key_file)
          timeout = "2m"
          host    = digitalocean_droplet.hdGuild-jenkins.ipv4_address
      }

    # initial setup for ubuntu install
    provisioner "remote-exec" {
      script = var.initial_server_setup_script
    }
    
    # install ngninx server
    provisioner "remote-exec" {
      inline = [
        "export PATH=$PATH:/usr/bin",
        # install nginx
        "sudo apt-get update",
        "sudo apt-get -y install nginx"
      ]
    }
}