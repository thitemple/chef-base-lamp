#!/bin/bash
#
# Install Ruby
#
sudo rpm -Uvh http://rbel.frameos.org/rbel5
sudo yum install ruby ruby-devel ruby-ri ruby-rdoc ruby-shadow gcc gcc-c++ automake autoconf make curl dmidecode -y

#
# Install RubyGems
#k
curl -O http://production.cf.rubygems.org/rubygems/rubygems-1.8.10.tgz
tar zxf rubygems-1.8.10.tgz
sudo ruby rubygems-1.8.10/setup.rb --no-format-executable
rm -rf rubygems-1.8.10
rm rubygems-1.8.10.tgz

#
# Install SVN
#
sudo yum install subversion -y

#
# Install Chef
#
sudo gem install chef --no-ri --no-rdoc
sudo mkdir /etc/chef
cd /etc/chef

#
# Adding REPL to yum
#
sudo rpm -Uvh http://fedora.mirror.nexicom.net/epel/5/i386/epel-release-5-4.noarch.rpm
sudo yum install yum-protectbase -y

#
# Install GIT
#
sudo yum install git -y

# sudo git clone git://github.com/vintem/chef-base-lamp.git .
# sudo chef-solo -c config/solo.rb -j config/node.json