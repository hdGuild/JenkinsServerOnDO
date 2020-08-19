# Master server install

this folder is for master server golden deployment. Means prerequisites deployment before any automatized deployment can be proceed.

prequisites consists on :

## 1. code prepare

before automated deployment can be done, it is needed to open ssh connection with Git repositories.

The ssh connection is made following these steps :

1. ssh configuration :
    - putty uses .ppk private key that are not supported by openssh.
    - git uses standard openssh private key, not .ppk format.
    - to see openssh format of putygen ssh key, do load the .ppk with puttygen (see  [how to add ssh-keys to account](https://www.digitalocean.com/docs/droplets/how-to/add-ssh-keys/to-account/) )
    - add in ~/.ssh/config file, the git ssh IdentityFile as private key to test for ssh connection.

            [remote "origin"]
            url = git@github.com:hdGuild/JenkinsServerOnDO.git
            fetch = +refs/heads/*:refs/remotes/origin/*
            identityfile= C:\\Users\\Philippe/.ssh/git_id_rsa

    - as windows openssh does not support ssh agent, do not use passphrase on private keys to use with github !
    - DigitalOcean does use Key ID rather than Key itself :

        *hi, instead of the actual key you have to send the ID of the key.*

        1. generate the key (for igitalOcean)
        2. add your public key via <https://cloud.digitalocean.com/ssh_keys> or API <https://developers.digitalocean.com/documentation/v2/#create-a-new-key>
        3. get the ID of the added public key via API call curl -X GET -H ‘Content-Type: application/json’ -H 'Authorization: Bearer 40e0f142bf2fcdeeaec672a92ca307b0c9de838a4faac51585df26c56eab2541’ <https://api.digitalocean.com/v2/account/keys>
        4. use this ID for you droplet creation call: …,“ssh_keys”:[123456]… enjoy!

## deploying droplet

### deploying centOS server on the droplet with ssh access restriction

    0. Deploy CentOs7 server on DigitalOcean using terraform. (see: https://www.digitalocean.com/community/tutorials/how-to-use-terraform-with-digitalocean)

    1. scripting CentOS7 initial server setup (see: https://www.digitalocean.com/community/tutorials/initial-server-setup-with-centos-7)

    2. jenkins install on CentOS 7 server (see: https://www.digitalocean.com/community/tutorials/how-to-set-up-jenkins-for-continuous-development-integration-on-centos-7)

    3. scripting Jenkins initial setup (see differents web pages on jenkins initial setup)

    4. Install Ansible on CentOS 7 server (see : https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-centos-7)

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

## using jenkins CLI from commanbd line

1. wget localhost:8080/jnlpJars/jenkins-cli.jar
2. java -jar jenkins-cli.jar -auth admin_name:admin_password -s <http://127.0.0.1:8080/> help

## Storyline

    1. DONE : Deploy Ubuntu server using terraform with initial setup by script 
    2. DONE : Change to deploy CentOS server using terraform
    3. DONE : create bash script for initial CentOS server setup
    4. organize Terraform code using modules
        1. Deploy and use KeyVault values in server setup and terraform scripts
    5. DONE : Deploy Jenkins server in CentOS
    6. configure jenkins server on CentOS for use
    7. FOR UPDATE : Use Ansible to do the above scripting configuration
    8. DONE : Deploy Ansible on Jenkins server
    9. Deploy Hashicorp Vault on jenkins' CentOs server
        see : https://phoenixnap.com/kb/how-to-install-vault-on-centos-7#htoc-initialize-and-unseal-vault
    10. Use the vault for Secrets deployment as jenkins user name and password
    11. use jenkins pipeline to deploy Ubuntu server using terraform for HDWebSite
    12. use jenkins pipeline to set up a LEMP on Ubuntu server using Ansible (see : https://www.digitalocean.com/community/tutorials/how-to-use-ansible-to-install-and-set-up-lemp-on-ubuntu-18-04)
