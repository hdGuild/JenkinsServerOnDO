#!/bin/bash
#
# this script installs Ansible on a CentOS server
# see https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-ansible-on-centos-7 
# for details

set -euo pipefail

echo 'script ansibleInstallOnCentOS.sh running'

# first ensure that the CentOS 7 EPEL repository is installed:
yum -y install epel-release

# Once the repository is installed, install Ansible
yum -y install ansible
