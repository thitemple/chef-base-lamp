directory "/etc/dbconfig-common/" do
  action :create
  recursive true
end

template "/etc/dbconfig-common/phpmyadmin.conf" do
  source "phpmyadmin.conf.erb"
  mode "0660"
  variables(:password => node[:mysql][:server_root_password], :username => 'root', :host => 'localhost')
end

if platform?(%w{centos})

  execute "install phpMyAdmin dependencies for php 5.3" do
    command "sudo yum install php53-mysqli php53-mcrypt php53-mbstring -y"
    action :run
    only_if "rpm -V php53-common"
  end

  execute "install phpMyAdmin dependencies for php 5.2" do
    command "sudo yum --enablerepo=remi,remi-test install php-mysqli php-mcrypt php-mbstring -y"
    action :run
    not_if "rpm -V php53-common"
  end
  
  execute "install phpMyAdmin" do
	command "sudo yum --enablerepo=remi install phpmyadmin -y"
	action :run
  end
  
  template "/etc/httpd/conf.d/phpMyAdmin.conf" do
	source "phpmyadmin.conf.http.erb"
	mode  "0660"
  end
  
else

  package "phpmyadmin"
  
end

template 

service "httpd" do
  action :restart
end
