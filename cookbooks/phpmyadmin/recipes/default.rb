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
    command "sudo yum install php53-mcrypt php53-mbstring -y"
    action :run
    only_if "rpm -V php53-common"
  end

  execute "install phpMyAdmin dependencies for php 5.2" do
    command "sudo yum --enablerepo=remi,remi-test install php-mcrypt php-mbstring -y"
    action :run
    not_if "rpm -V php53-common"
  end

end

package "phpmyadmin"

service "httpd" do
  service_name "httpd"
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

# sudo cp /var/www/phpmyadmin/config.sample.inc.php /var/www/phpmyadmin/config.inc.php
