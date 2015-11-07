#!/bin/bash

# Start mysql service and create a database called devops
service mysql start
MYSQL=`which mysql`
$MYSQL -u root -e "CREATE DATABASE IF NOT EXISTS devops"

# Run your project in production mode.
# You need to run it as a devops user because 
# some of the tools are not meant to be run by the root user
cd $HOME/sandboxes
sudo -u devops -H sh -c "mvn -Pprod spring-boot:run"  
