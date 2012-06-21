directory "/usr/local/solr" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

remote_file "/usr/local/solr/apache-solr-" + node[:solr][:version] + ".tgz" do
  source "http://apache.openmirror.de/lucene/solr/" + node[:solr][:version] + "/apache-solr-" + node[:solr][:version] + ".tgz"
end

execute "extract" do
  command "tar zxf apache-solr-" + node[:solr][:version] + ".tgz"
  cwd "/usr/local/solr"
end

template "/etc/init.d/solr" do
  source "solr.erb"
  mode "0755"
  group "root"
  owner "root"
end

service "solr" do
  service_name "solr"
  supports :status => true, :restart => true, :reload => true
  action :nothing
end 