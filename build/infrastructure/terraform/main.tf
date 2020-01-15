# data file to be red for security content
# security inpût variables for terraform
# personnal access token "HDGuild_Terraform2DigitalOcean" : value setted in keepass on dropbox

# creates the droplet on Digital Ocean 
resource "digitalocean_droplet" "hdGuild-jenkins" {
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
          host    = var.server_host_url
      }

    # initial setup for ubuntu install

    
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