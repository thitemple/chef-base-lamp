#
# Cookbook Name:: apache2
# Recipe:: php5 
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform']
when "debian", "ubuntu"
  package "libapache2-mod-php5" do
    action :install
  end  

when "arch"
  package "php-apache" do
    action :install
    notifies :run, resources(:execute => "generate-module-list"), :immediately
  end

when "amazon", "redhat", "centos", "scientific"
  
  # package "php package" do
   # package_name "php-5.2.17"
   # action :install
   # notifies :run, resources(:execute => "generate-module-list"), :immediately
   # not_if "which php"
  # end
  
  execute "import rpm key" do
	command "rpm --import http://www.jasonlitka.com/media/RPM-GPG-KEY-jlitka"
	action :run
  end
  
  template "/etc/yum.repos.d/utterramblings.repo" do
	source "utterramblings.repo.erb"
	mode "0644"
  end
  
  execute "update yum" do
	command "yum update -y"
	action :run
  end
  
  execute "yum list php" do
	command "yum list php"
	action :run
  end
  
  execute "sleep" do
	command "sleep 30"
	action :run
  end
  
  yum_package "php" do
    version "5.2.17-jason.2"
	action :install
  end
  
  yum_package "php-common" do
	version "5.2.17-jason.2"
	action :install
  end
  
  yum_package "php-mysqli" do
	version "5.2.17-jason.2"
	action :install
  end
  
  yum_package "php-mcrypt" do
	version "5.2.17-jason.2"
	action :install
  end
  
  yum_package "php-mbstring" do
	version "5.2.17-jason.2"
	action :install
  end

  # delete stock config
  file "#{node['apache']['dir']}/conf.d/php.conf" do
    action :delete
  end

  # replace with debian style config
  template "#{node['apache']['dir']}/mods-available/php5.conf" do
    source "mods/php5.conf.erb" 
    notifies :restart, "service[apache2]"
  end

when "fedora"
  package "php package" do
    package_name "php"
    action :install
    notifies :run, resources(:execute => "generate-module-list"), :immediately
    not_if "which php"
  end

  # delete stock config
  file "#{node['apache']['dir']}/conf.d/php.conf" do
    action :delete
  end

  # replace with debian style config
  template "#{node['apache']['dir']}/mods-available/php5.conf" do
    source "mods/php5.conf.erb" 
    notifies :restart, "service[apache2]"
  end

when "freebsd"
  freebsd_port_options "php5" do
    options "APACHE" => true
    action :create
  end

  package "php package" do
     package_name "php5"
     source "ports"
     action :install
     notifies :run, resources(:execute => "generate-module-list"), :immediately
  end

  # replace with debian style config
  template "#{node['apache']['dir']}/mods-available/php5.conf" do
    source "mods/php5.conf.erb"
    notifies :restart, "service[apache2]"
  end
end

apache_module "php5" do
  case node['platform']
  when "redhat","centos","scientific","amazon","fedora","freebsd"
    filename "libphp5.so"
  end
end

template "/var/www/phpdata.php" do
  source "phpdata.php.erb"
  mode "0755"
end
