# db_master = node[:scalarium][:roles]['db-master'][:instances].keys.first

template "/etc/phpmyadmin/config-db.php" do
  source "config-db.php.erb"
  owner 'www-data'
  mode "0660"
  variables(:password => node[:mysql][:server_root_password], :username => 'root', :host => 'localhost' rescue nil) )
end