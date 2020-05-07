#!/bin/bash
set -euo pipefail

########################
### SCRIPT VARIABLES ###
########################

# Name of the user to create and grant sudo privileges
USERNAME="Alaster"

# Whether to copy over the root user's `authorized_keys` file to the new sudo
# user.
COPY_AUTHORIZED_KEYS_FROM_ROOT=true

# Additional public keys to add to the new sudo user
# these are the other public key to add (ex : other workstation) 
 OTHER_PUBLIC_KEYS_TO_ADD=(
    "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAgEAkfRte4HRJhB2k3cZkmYLIcPmPl2sEyU4mNbYpEXxXFXzMBUrciyqoZxJJxR03h4wvT25iMNdub9Xw+I3GrBioDgo6w3Ey/ZPWfjqKUNdglnUh5bGl0d4NH7IYv5im6656iGyUVqPfXQfLeC1ureyp6d036KX/vZEX+db+qAF8grjRPnFTPzXV/08klFq1GGjWFScqFJNamUhYk+piAUxJlhGPkcCtt67xolgijcOKULzIEn+PqwACZ0PM4mOZdNLgFdrZUm2xBM3UL//BBjB9CUxakfMgNrkyWsC//CF/WRmmeqj4nfVr1ZKjxjUJAltJjA6UYRO6hkLM0msbQ2nt1JfSUKz1tvo0X61vYrvxPDQ0EczCfmco1fOs7MFMZR6onzZxnu6PZjz+UB4OkmafQb42O0bJWLYTndGoW2u1Cj1sXDfgLy8yJdsGGBfJQGOKAx098PMhJmq5t7Pa87LVXhvAxxlXDGYhpUMh68xatnK1owsXRIfVCnXwHEeWoNeg55rTrPou2USvpTkoBoIRuZkkj71T5RDsiOc0/vVEw3KyzJjbqq3VyWhgfO1U5Ee4/SPwT9+BBHiW8/PsDmrLwo7JIUGwMP4Vyb8EKTmG7WkGVhXJ3ShPs0MQ0HTxf/F4kVSt9HkFVVX3rXb7WVMFb1KBT+ZlyOm9rWQ+Y/Nhas= rsa-key-20200428",
    "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAwi4w/EgIwiwz9eZEM18U+7aU3pIhJZjVGcYRxU78sVzwP/ELalWMBXHcYo9UW4hj0fhXLvPpogbZFaQkoJHXpUej2vbbUyrl7ZzW/NRhVrGnjG/2qILzX0pPFit8EPXGRJexHJJaUFlCgHZlz8IM/terbNirddqhkxtuGej1/RUnCinsbmQiMiJt9s42UL5Z8UAF16miCcCYhZaVhEMuBzQa3j4ZVJY5FA+rEtvATXU9ytCFN1pC8tS0PRsg8GTSo3oGerZIvA17LNzzZXsBjj8ej9cvNIv9N8HrchXIiM+wer0hPDZZfZYURjJnef0sCajYQF/Bj4o+9OW0IprZSw== rsa-key-20170125"
 )

####################
### SCRIPT LOGIC ###
####################

# Add sudo user and grant privileges
useradd --create-home --shell "/bin/bash" --groups sudo "${USERNAME}"

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

# Add exception for SSH and then enable UFW firewall
ufw allow OpenSSH
ufw --force enable
