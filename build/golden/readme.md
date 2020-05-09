# Jenkins server install

this folder is for golden deployment : prerequisites deployment before any automatized deployment.
prequisites consist on :

## code prepare

1. ssh configuration :
    - putty uses .ppk private key that are not supported by openssh.
    - git uses standard openssh private key, not .ppk format.
    - to see openssh format of putygen ssh key, do load the .ppk with puttygen (see  <https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/to-account/>)
    - needs to add in ~/.ssh/config file, the git ssh IdentityFile as private key to test for ssh connection.
    - windows openssh does not support ssh agent, so do not use passphrase on windows openssh private keys to use with github !
    - DigitalOcean does use Key ID rather than Key itself :
        hi, instead of the actual key you have to send the ID of the key.

        1. generate the key (which it looks like you’ve already done)
        2. add your public key via <https://cloud.digitalocean.com/ssh_keys> or API <https://developers.digitalocean.com/documentation/v2/#create-a-new-key>
        3. get the ID of the added public key via API call curl -X GET -H ‘Content-Type: application/json’ -H 'Authorization: Bearer 40e0f142bf2fcdeeaec672a92ca307b0c9de838a4faac51585df26c56eab2541’ <https://api.digitalocean.com/v2/account/keys>
        4. use this ID for you droplet creation call: …,“ssh_keys”:[123456]… enjoy!

## deploying droplet

### deploying ubuntu server on the droplet with ssh access restriction

    0. manual installation at <https://medium.com/@adrian.gheorghe.dev/how-to-use-terraform-and-ansible-to-raise-a-jenkins-server-on-digitalocean-15246b687666>

    1. Install Ansible on Windows 10 at : <https://www.youtube.com/watch?v=4sMFybv74Uo>

### SSL certificate to ensure Vault's HTTP API

    1. using Let's Encrypt service

### Key vault deployment where to keep secrets

- to deploy the prequisite, we follow the digitalocean guide at : <https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean>
- debbuging terraform at : <https://www.terraform.io/docs/internals/debugging.html>

## to run prequisite

- go to build\golden\terraform
- run "terraform init"
- terraform plan -var-file= "..\configuration\<env>\<station>\tfparams.tfvars
- terraform apply -var-file= "..\configuration\<env>\<station>\tfparams.tfvars

## Storyline

    1. DONE : Deploy Ubuntu server using terraform with initial setup by script 
    2. DONE : Change to deploy CentOS server using terraform
    3. DONE : create bash script for initial CentOS server setup
    4. organize Terraform code using modules
        1. Deploy and use KeyVault values in server setup and terraform scripts
    5. DONE : Deploy Jenkins server in CentOS
    6. configure jenkins server on CentOS for use
    7. FOR UPDATE : Use Ansible to do the above scripting configuration
