execute "Installing Remi repository" do
  if node['platform_version'].to_f < 6.0
    command "sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm; sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-5.rpm"
  else
    command "sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-7.noarch.rpm; sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm"
  end
  action :run
end

execute "Installing MySQL 5.5" do
  command "sudo yum --enablerepo=remi,remi-test install mysql mysql-server"
  action :run
end

directory node['mysql']['confd_dir'] do
  owner "mysql" unless platform? 'windows'
  group "mysql" unless platform? 'windows'
  action :create
  recursive true
end

service "mysql" do
  service_name node['mysql']['service_name']
  if node['mysql']['use_upstart']
    restart_command "restart mysql"
    stop_command "stop mysql"
    start_command "start mysql"
  end
  supports :status => true, :restart => true, :reload => true
  action :nothing
end

skip_federated = case node['platform']
                 when 'fedora', 'ubuntu', 'amazon'
                   true
                 when 'centos', 'redhat', 'scientific'
                   node['platform_version'].to_f < 6.0
                 else
                   false
                 end

template "#{node['mysql']['conf_dir']}/my.cnf" do
  source "my.cnf.erb"
  owner "root" unless platform? 'windows'
  group node['mysql']['root_group'] unless platform? 'windows'
  mode "0644"
  notifies :restart, resources(:service => "mysql"), :immediately
  variables :skip_federated => skip_federated
end

unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

# set the root password on platforms
# that don't support pre-seeding
unless platform?(%w{debian ubuntu})

  execute "assign-root-password" do
    command "\"#{node['mysql']['mysqladmin_bin']}\" -u root -h localhost password #{node['mysql']['server_root_password']}"
    action :run
    only_if "\"#{node['mysql']['mysql_bin']}\" -u root -e 'show databases;'"
  end

end

grants_path = node['mysql']['grants_path']

begin
  t = resources("template[#{grants_path}]")
rescue
  Chef::Log.info("Could not find previously defined grants.sql resource")
  t = template grants_path do
    source "grants.sql.erb"
    owner "root" unless platform? 'windows'
    group node['mysql']['root_group'] unless platform? 'windows'
    mode "0600"
    action :create
  end
end

if platform? 'windows'
  windows_batch "mysql-install-privileges" do
    command "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }\"#{node['mysql']['server_root_password']}\" < \"#{grants_path}\""
    action :nothing
    subscribes :run, resources("template[#{grants_path}]"), :immediately
  end
else
  execute "mysql-install-privileges" do
    command "\"#{node['mysql']['mysql_bin']}\" -u root #{node['mysql']['server_root_password'].empty? ? '' : '-p' }#{node['mysql']['server_root_password']} < \"#{grants_path}\""
    action :nothing
    subscribes :run, resources("template[#{grants_path}]"), :immediately
  end
end