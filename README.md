# docker-devops development env
The present docker is an extension of the Jhipster docker, including a MySql database, Grunt, Bower, and a bash script which creates a database and runs the application using the production profile.

# Introduction
This docker is an extension of Dubois docker, including a MySql database, Grunt, Bower, and a bash script which creates a database and runs the application using the production profile.

# Usage
to obtain the docker image run this command:

docker pull dieple/docker-devops

Once the image is downloaded, you will need to run your application inside the container and forward all local ports exposed (8080 for tomcat, 3000 and 3001 for grunt, 22 for ssh and 3606 for mysql). Try running the following command  and don’t forget to change “your_app_folder” to your local path:

sudo docker run -v /sandboxes:/sandboxes -p 8080:8080 -p 3000:3000 -p 3001:3001 -p 4022:22 -p 3306:3306 -t -i dieple/docker-devops /bin/bash

Finally you will need to run the script in /usr/local/bin, to start the mysql service and run the application using the production profile.


sudo sh /usr/local/bin/script.sh
sudo chown devops /sandboxes
cd /sandboxes
yo jhipster

# Change the database name

By default, the script will start the mysql service and will create a database called “devops”. If you would like to change the database name, you will need to modify the script on /usr/local/bin/script.sh:

Use your favourite editor and add your database name at the end of the line 6, instead of “devops”.

# Start Grunt

If you would like to see any change on the client side and reload your web application instantly then you will need to run the grunt server task. For this purpose, you will need to open a new terminal, access to your container and run grunt following these steps:

* Open a new terminal
* Get your container ID or name
**List your active containers by running:
  sudo docker ps
**Copy the container Id or the name
* Access your container:
  sudo docker exec -i -t CONTAINER_ID bash
* Start grunt serve task:
 grunt serve


