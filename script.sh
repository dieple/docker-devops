#!/bin/bash

# Start mysql service and create a database called awsctl
service mysql start
MYSQL=`which mysql`
$MYSQL -u root -e "CREATE DATABASE IF NOT EXISTS awsctl"

# Run your project in production mode.
# You need to run it as a devops user because 
# some of the tools are not meant to be run by the root user
cd /jhipster
#sudo -u devops -H sh -c "mvn -Pprod spring-boot:run"  
sudo -u devops -H sh -c "mvn spring-boot:run"  

