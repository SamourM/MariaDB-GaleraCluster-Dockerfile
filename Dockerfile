FROM ubuntu:18.04
MAINTAINER mohammad samour <mohammad.samour@arabot.io>

# add the universe repo
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
# update apt
RUN apt-get -q -y update
# install software-properties-common for key management
RUN apt-get -y install software-properties-common
# add the key for Mariadb Ubuntu repos
RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
# add the MariaDB repository
RUN sh -c "echo 'deb https://mirrors.evowise.com/mariadb/repo/10.2/ubuntu '$(lsb_release -cs)' main' > /etc/apt/sources.list.d/MariaDB102.list"
RUN apt install rsync
# update apt again
RUN apt-get -q -y update
RUN apt install mariadb-server mariadb-client
ADD ./cluster.cnf /etc/mysql/conf.d/cluster.cnf
# startup the service - this will fail since the nodes haven't been configured on first boot
RUN service mysql restart
# open the ports required to connect to MySQL and for Galera SST / IST operations
EXPOSE 3306 4444 4567 4568
