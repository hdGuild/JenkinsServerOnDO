#!/bin/bash
#
# this file will configure Jenkins for first use
# see https://riptutorial.com/jenkins/example/24925/disable-setup-wizard
# run this script as root 

echo 'script jenkins_initial_config.sh running'

# removing "unlockJenkins Start screen" - using groovy script 
# rem : unlock code at : /root/.jenkins/secrets/initialAdminPassword
## create groovy script
touch basic-security.groovy

printf '#!groovy

import jenkins.model.*
import hudson.util.*;
import jenkins.install.*;

def instance = Jenkins.getInstance()

instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)' > basic-security.groovy

mkdir --parents /root/.jenkins/init.groovy.d ; mv basic-security.groovy $_

## restart the service 
systemctl restart jenkins.service

## delete the groovy script
rm -f /root/.jenkins/init.groovy.d/basic-security.groovy

# create default user for jenkins use
touch basic-security.groovy

printf '#!groovy

import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

def hudsonRealm = new HudsonPrivateSecurityRealm(false)

hudsonRealm.createAccount("admin_name","admin_password")
instance.setSecurityRealm(hudsonRealm)
instance.save()' > basic-security.groovy

mkdir --parents /root/.jenkins/init.groovy.d ; mv basic-security.groovy $_
systemctl restart jenkins.service
rm -f /root/.jenkins/init.groovy.d/basic-security.groovy

echo 'using jenkins CLI from commanbd line : ' 
echo '1. wget localhost:8080/jnlpJars/jenkins-cli.jar'
echo '2. java -jar jenkins-cli.jar -s http://127.0.0.1:8080/ help'