This project is to automatize jenkins server deployment on a Digital Ocean droplet using Terraform.
1. Github configuration
    1. to use SSH key with GitHub it is needed the following :
        1. a SSH key pair RSA2 typed with 4096 bits without passphrase
        2. set the public key as SSH key for your githib account
        3. set the private key as git ssh key on .git/config file on project folder :
            [remote "origin"]
                url = git@github.com:hdGuild/JenkinsServerOnDO.git
                fetch = +refs/heads/*:refs/remotes/origin/*
                identityfile= C:\\Users\\Philippe/.ssh/git_id_rsa

2. Repository structure
    1. Build folder contains the sources to build for release
        1. Application folder gets the application source code. 
            Each application should have its own folder
        2. infrastructure folder contains the source for infrastructure deployment
            contains configuration per environment, scripts for deployment or to deploy, terraform source code
    2. golden folder contains prerequisite deployment before automated deplyment can process
    3. deploy folder contains the pipelines to automate deployments