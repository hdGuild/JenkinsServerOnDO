this folder is for golden deployment : prerequisites deployment before any automatized deployment.
prequisites consist on : 
- code prepare :
    1. ssh configuration :
        - putty uses .ppk private key that are not supported by openssh.
        - git uses standard openssh private key, not .ppk format. 
        - needs to add in ~/.ssh/config file, the git ssh IdentityFile as private key to test for ssh connection.
        - windows openssh does not support ssh agent, so do not use passphrase on windows openssh private keys to use with github !
- deploying droplet
- deploying ubuntu server on the droplet with ssh access restriction
    0. manual installation at https://medium.com/@adrian.gheorghe.dev/how-to-use-terraform-and-ansible-to-raise-a-jenkins-server-on-digitalocean-15246b687666 
- SSL certificate to ensure Vault's HTTP API
    1. using Let's Encrypt service
- Key vault deployment where to keep secrets
- to deploy the prequisite, we follow the digitalocean guide at : https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean
- debbuging terraform at : https://www.terraform.io/docs/internals/debugging.html
    - deploying droplet
    - deploying ubuntu server on the droplet with ssh access restriction
    - SSL certificate to ensure Vault's HTTP API
    - Key vault deployment where to keep secrets
to run prequisite :
- go to build\golden\terraform
- run "terraform init"
- terraform plan -var-file= "..\configuration\<env>\<station>\tfparams.tfvars
- terraform apply -var-file= "..\configuration\<env>\<station>\tfparams.tfvars

