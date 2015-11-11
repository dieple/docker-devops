# DOCKER-VERSION 0.1.0
FROM      ubuntu:14.04
MAINTAINER Diep Le

# make sure the package repository is up to date
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get -y update

# install python-software-properties (so you can do add-apt-repository)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q python-software-properties software-properties-common && apt-get clean

# install SSH server so we can connect multiple times to the container
RUN apt-get -y install openssh-server && mkdir /var/run/sshd && apt-get clean

# install oracle java from PPA
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get -y install oracle-java8-installer && apt-get clean

# Set oracle java as the default java
RUN update-java-alternatives -s java-8-oracle
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-8-oracle" >> ~/.bashrc

# install utilities
RUN apt-get -y install vim git sudo zip bzip2 fontconfig curl && apt-get clean

# install chefdk
RUN apt-get update \
	&& curl -L https://www.opscode.com/chef/install.sh | sudo bash -s -- -P chefdk \
	&& locale-gen en_US.UTF-8

# install maven
RUN apt-get -y install maven && apt-get clean

# install node.js from PPA
#RUN add-apt-repository ppa:chris-lea/node.js
#RUN apt-get update
#RUN apt-get -y install nodejs
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash - && \
    apt-get -y install nodejs && \
    apt-get clean &&\
    rm -rf /var/lib/dpkg/info/* &&\
    rm -rf /var/lib/apt


# install yeoman
RUN npm install -g yo

# install JHipster
RUN npm install -g generator-jhipster@2.23.0

# Install Bower & Grunt
RUN npm install -g bower grunt-cli

# configure the "devops" and "root" users
RUN echo 'root:devops' |chpasswd
RUN groupadd devops && useradd devops -s /bin/bash -m -g devops -G devops && adduser devops sudo
RUN echo 'devops:devops' |chpasswd

# Install MySQL.
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server && \
  rm -rf /var/lib/apt/lists/* && \
  sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf && \
  sed -i 's/^\(log_error\s.*\)/# \1/' /etc/mysql/my.cnf && \
  echo "mysqld_safe &" > /tmp/config && \
  echo "mysqladmin --silent --wait=30 ping || exit 1" >> /tmp/config && \
  echo "mysql -e 'GRANT ALL PRIVILEGES ON *.* TO \"root\"@\"%\" WITH GRANT OPTION;'" >> /tmp/config && \
  bash /tmp/config && \
  rm -f /tmp/config

# Copy the script attached to /usr/local/bin
# The script needs to be in the same directory as the Dockerfile
COPY script.sh /usr/local/bin/

# Define mountable directories for mysql. 
VOLUME ["/etc/mysql", "/var/lib/mysql"]

# Define working directory.
VOLUME ["/jhipster"]
WORKDIR /jhipster
#USER devops
#RUN cd /home/devops \
#	&& git clone https://github.com/dieple/jhipster-2.23.0.git jhipster \
#	&& cd /home/devops/jhipster \
#	&& mvn spring-boot:run

# expose the working directory, the Tomcat port, the Grunt server port, Mysql, the SSHD port, and run SSHD
EXPOSE 8080
EXPOSE 3000
EXPOSE 3001
EXPOSE 3306
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
