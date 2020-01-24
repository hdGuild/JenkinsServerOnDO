This project is to automatize jenkins server deployment on a Digital Ocean droplet using Terraform.
1. Repository structure
    1. Build folder contains the sources to build for release
        1. Application folder gets the application source code. 
            Each application should have its own folder
        2. infrastructure folder contains the source for infrastructure deployment
            contains configuration per environment, scripts for deployment or to deploy, terraform source code
    2. golden folder contains prerequisite deployment before automated deplyment can process
    3. deploy folder contains the pipelines to automate deployments