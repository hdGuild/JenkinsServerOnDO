#!/bin/bash
#
# centos-setup.sh
#
# based on https://www.digitalocean.com/community/tutorials/additional-recommended-steps-for-new-centos-7-servers
set -euo pipefail

########################
### SCRIPT VARIABLES ###
########################

# Current directory
CWD=$(pwd)

# Defined users
USERS="$(ls -A /home)"

# Admin user
ADMIN=$(getent passwd 1000 | cut -d: -f 1)

# Log
LOG="/tmp/initial_setup.log"
# redirect outputs to $~LOG} file
echo >> ${LOG}

# Name of the user to create and grant sudo privileges
USERNAME="Alaster"

# Whether to copy over the root user's `authorized_keys` file to the new sudo
# user.
COPY_AUTHORIZED_KEYS_FROM_ROOT=true

# Additional public keys to add to the new sudo user
# these are the other public key to add (ex : other workstation) 
 OTHER_PUBLIC_KEYS_TO_ADD=(
    "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAwi4w/EgIwiwz9eZEM18U+7aU3pIhJZjVGcYRxU78sVzwP/ELalWMBXHcYo9UW4hj0fhXLvPpogbZFaQkoJHXpUej2vbbUyrl7ZzW/NRhVrGnjG/2qILzX0pPFit8EPXGRJexHJJaUFlCgHZlz8IM/terbNirddqhkxtuGej1/RUnCinsbmQiMiJt9s42UL5Z8UAF16miCcCYhZaVhEMuBzQa3j4ZVJY5FA+rEtvATXU9ytCFN1pC8tS0PRsg8GTSo3oGerZIvA17LNzzZXsBjj8ej9cvNIv9N8HrchXIiM+wer0hPDZZfZYURjJnef0sCajYQF/Bj4o+9OW0IprZSw== rsa-key-20170125"
 )

####################
### SCRIPT LOGIC ###
####################

# Add sudo user and grant privileges
adduser --create-home --shell "/bin/bash" --groups wheel "${USERNAME}"

# Check whether the root account has a real password set
encrypted_root_pw="$(grep root /etc/shadow | cut --delimiter=: --fields=2)"

if [ "${encrypted_root_pw}" != "*" ]; then
    # Transfer auto-generated root password to user if present
    # and lock the root account to password-based access
    echo "${USERNAME}:${encrypted_root_pw}" | chpasswd --encrypted
    passwd --lock root
else
    # Delete invalid password for user if using keys so that a new password
    # can be set without providing a previous value
    passwd --delete "${USERNAME}"
fi

# Expire the sudo user's password immediately to force a change
chage --lastday 0 "${USERNAME}"

# Create SSH directory for sudo user
home_directory="$(eval echo ~${USERNAME})"
mkdir --parents "${home_directory}/.ssh"

# Copy `authorized_keys` file from root if requested
if [ "${COPY_AUTHORIZED_KEYS_FROM_ROOT}" = true ]; then
    cp /root/.ssh/authorized_keys "${home_directory}/.ssh"
fi

# Add additional provided public keys
for pub_key in "${OTHER_PUBLIC_KEYS_TO_ADD[@]}"; do
    echo "${pub_key}" >> "${home_directory}/.ssh/authorized_keys"
done

# Adjust SSH configuration ownership and permissions
chmod 0700 "${home_directory}/.ssh"
chmod 0600 "${home_directory}/.ssh/authorized_keys"
chown --recursive "${USERNAME}":"${USERNAME}" "${home_directory}/.ssh"

# Disable root SSH login with password
sed --in-place 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
if sshd -t -q; then
    systemctl restart sshd
fi

# disallow remote root login
# this will be done after server configuration
<<<<<<< Updated upstream
sed --in-place 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
=======
#sed --in-place 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
>>>>>>> Stashed changes

# the reload ssh daemon
systemctl reload sshd

# additionnal CentOS server setup 
# firewall install 
yum install -y firewalld
# start firewall 
systemctl start firewalld
# enabled ssh service through firewall
firewall-cmd --permanent --add-service=ssh

# if ssh port have change in the server then use bellow : 
# sudo firewall-cmd --permanent --remove-service=ssh
# sudo firewall-cmd --permanent --add-port=4444/tcp

# If you plan on running a conventional HTTP web server, you will need to enable the http service:
# sudo firewall-cmd --permanent --add-service=http

# If you plan to run a web server with SSL/TLS enabled, you should allow traffic for https as well:
# sudo firewall-cmd --permanent --add-service=https

# If you need SMTP email enabled, you can type:
# sudo firewall-cmd --permanent --add-service=smtp

# To see any additional services that you can enable by name, type:
# firewall-cmd --get-services

# When you are finished, you can see the list of the exceptions that will be implemented by typing:
# sudo firewall-cmd --permanent --list-all

# When you are ready to implement the changes, reload the firewall:
firewall-cmd --reload
# If, after testing, everything works as expected, you should make sure the firewall will be started at boot:
systemctl enable firewalld

# Configure Timezones
timedatectl set-timezone Europe/Paris

# Configure NTP Synchronization
yum install -y ntp

# start ntp for any sessions
systemctl start ntpd
systemctl enable ntpd

# creates swap file 
fallocate -l 4G /swapfile
chmod 600 /swapfile
#  tell the system it can use the swap file by typing:
mkswap /swapfile
#  modify a system file so that our server will do this automatically at boot
sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab'
