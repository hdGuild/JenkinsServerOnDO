#!/bin/bash

# this script will install Jenkins on a CentOS 7 server.
# using https://www.digitalocean.com/community/tutorials/how-to-set-up-jenkins-for-continuous-development-integration-on-centos-7

set -euo pipefail

# we will install Jenkins using WAR file running as instaled under centos 7
echo 'script jenkinsInstallOnCentOS.sh running'

# Step 1 — Installing Jenkins
## install java
yum -y install java

## install jenkins from WAR file
## install wget
yum -y install wget
wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war

# Step 2 - Running Jenkins as a Service
## First, make sure the WAR file you’ve downloaded 
## is sitting in a location convenient for long-term storage and use:
mv jenkins.war /usr/local/bin/jenkins.war

### create jenkins.service file 
touch jenkins.service
### add content to file
printf "[Unit]
Description=Jenkins Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/java -jar /usr/local/bin/jenkins.war
Restart=on-abort

[Install]
WantedBy=multi-user.target" > jenkins.service

### move to services folder
mv jenkins.service /etc/systemd/system/

### reload daemon
systemctl daemon-reload

### then start jenkins service
systemctl start jenkins.service

### stop the service
# systemctl stop jenkins.service
### restart the service 
# systemctl restart jenkins.service
## status check 
# systemctl status jenkins.service

# then adding jenkins service and port as firewall rule
firewall-cmd --zone=public --permanent --add-service=jenkins

# and reload firewall 
firewall-cmd --reload





