#!/bin/bash

#
# Install Ruby
#
#sudo rpm -Uvh http://rbel.frameos.org/rbel6
sudo apt-get install ruby ruby-devel ruby-ri ruby-rdoc ruby-shadow gcc gcc-c++ automake autoconf make curl dmidecode

#
# Install RubyGems
#
curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
tar zxf rubygems-1.8.10.tgz
sudo ruby rubygems-1.8.10/setup.rb --no-format-executable
rm -rf rubygems-1.8.10
rm rubygems-1.8.10.tgz

#
# Install SVN
#
sudo apt-get install svn git

#
# Install Chef
#
sudo gem install chef --no-ri --no-rdoc
sudo mkdir /etc/chef
cd /etc/chef

#
# Install GIT
#
#sudo yum install git

#
# Adding REPL to yum
#
#sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-7.noarch.rpm
#sudo apt-get install yum-plugin-protectbase.noarch

# sudo git clone git://github.com/vintem/chef-base-lamp.git .
# sudo chef-solo -c config/solo.rb -j config/node.json
# "/usr/bin/mysqladmin" -u root password Pa$$w0rd
# "/usr/bin/mysqladmin" -u root -h localhost password Pa$$w0rd
# "/usr/bin/mysql" -u root -e 'show databases;'
# service mysqld restart
# "/usr/bin/mysql" -u root -e "UPDATE mysql.user SET Password=PASSWORD('Pa$$w0rd') where User = 'root'; FLUSH PRIVILEGES;"