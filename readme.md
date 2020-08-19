# Master deploy server

*This server will get the necessary tools to automate deployment on HDGuilds projects.*
*The needed tools are listed bellow*

* Terraform (Cloud infrastructure deployment)
* Jenkins (CI/CD deployments)
* Ansible (configuration management)
* Hashicorp Vault (security)
* liquibase (Database update management)
* WP-Cli (Wordpress client)

**Resume :** This project is to automatize the *Master server* deployment. This server will contains all needed resources and tools that will be used for, mainly, the helldorado.fr website.

********

## 1. Github configuration to use with ssh

Using Github with ssh key (needed to automate deployments) needs the following :

1. SSH key pair RSA2 typed with 4096 bits without passphrase
2. set the public key as SSH key for your githib account
3. set the private key (git_id_rsa) as git ssh key on the .git/config file on project folder :

        [remote "origin"]
        url = git@github.com:hdGuild/JenkinsServerOnDO.git
        fetch = +refs/heads/*:refs/remotes/origin/*
        identityfile= C:\\Users\\Philippe/.ssh/git_id_rsa

## 2. Repository structure

The project is structured as bellow :

* Build folder contains the sources to build for release.
  * Application folder gets the application source code.
        *Each application should have its own folder*
  * infrastructure folder contains the source for infrastructure deployment
        *contains configuration per environment, scripts for deployment or to deploy, terraform source code*
* golden folder contains prerequisite deployment before automated deplyment can process. following tools will be installed by golden on the Master deploy server :
  * Jenkins
  * Ansible
  * Hashicorp Vault
* deploy folder contains the pipelines to automate deployments.
