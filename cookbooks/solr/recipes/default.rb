remote_file "/etc/apache-solr-3.6.0.tgz" do
  source "http://apache.openmirror.de/lucene/solr/3.6.0/apache-solr-3.6.0.tgz"
end

execute "extract" do
  command "tar zxf apache-solr-3.6.0.tgz"
  cwd "/etc"
end