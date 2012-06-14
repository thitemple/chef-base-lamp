execute "grant all privileges on database" do
  command "echo \"grant all privileges on *.* to 'root'@'%' identified by '#{node[:mysql][:server_root_password]}';\" | mysql -u root -p#{node[:mysql][:server_root_password]}"
end