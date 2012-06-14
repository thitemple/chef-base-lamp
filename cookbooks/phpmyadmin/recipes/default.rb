directory "/etc/dbconfig-common/" do
  action :create
  recursive true
end

template "/etc/dbconfig-common/phpmyadmin.conf" do
  source "phpmyadmin.conf.erb"
  mode "0660"
  variables(:password => node[:mysql][:server_root_password], :username => 'root', :host => 'localhost')
end

package "phpmyadmin"

template "/etc/phpmyadmin/config-db.php" do
  source "config-db.php.erb"
  owner 'www-data'
  mode "0660"
  variables(:password => node[:mysql][:server_root_password], :username => 'root', :host => 'localhost')
end

service "httpd" do
  service_name "httpd"
  supports :status => true, :restart => true, :reload => true
  action :nothing
end