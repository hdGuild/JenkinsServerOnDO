This project is to automatize jenkins server deployment on a Digital Ocean droplet using Terraform.
1. Repository structure
    Build folder contains the sources to build for release
    1. Application folder gets the application source code. 
        Each application should have its own folder
    2. infrastructure folder contains the source for infrastructure deployment
    3. deploy folder contains the pipelines to automatise deployments