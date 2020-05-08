#!/bin/bash

# this script will install Jenkins on a CentOS 7 server.
# using https://www.digitalocean.com/community/tutorials/how-to-set-up-jenkins-for-continuous-development-integration-on-centos-7

set -euo pipefail

# we will install Jenkins using WAR file running as instaled under centos 7

# Step 1 — Installing Jenkins
## install java
yum -y install java

## install jenkins from WAR file
