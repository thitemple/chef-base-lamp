if platform?(%w{centos})
	execute "Installing Remi repository" do
		if node['platform_version'].to_f < 6.0
			command = "sudo rpm -Uvh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm; sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-5.rpm"
		else
			command = "sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-7.noarch.rpm; rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm"
		end
		action :run
	end
end

include_recipe "mysql::server"