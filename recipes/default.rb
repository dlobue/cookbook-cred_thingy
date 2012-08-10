
package "python-virtualenv"
package "python-pip"
package "python-dev"
package "libevent-dev"


directory node.cred_thingy.conf_dir

template node.cred_thingy.upstart_conf.to_s do
    source "upstart.conf.erb"
    mode "0644"
    notifies :stop, 'service[cred_thingy]', :immediately
end

template node.cred_thingy.config.to_s do
    source "cred_thingy.conf.erb"
    mode "0644"
    notifies :stop, 'service[cred_thingy]', :immediately
end


git node.cred_thingy.dist_dir do
    repository node.cred_thingy.git_repo
    revision node.cred_thingy.dist_tag
    action [:checkout, :sync]
    notifies :run, "execute[setup cred_thingy virtualenv]"
    notifies :run, "script[install cred_thingy deps]"
    notifies :stop, "service[cred_thingy]", :immediately
end

execute "setup cred_thingy virtualenv" do
    command 'virtualenv --no-site-packages --distribute --prompt="(cred_thingy)" deps'
    creates node.cred_thingy.deps_dir
    cwd node.cred_thingy.dist_dir
end

script "install cred_thingy deps" do
    action :nothing
    interpreter "bash"
    cwd node.cred_thingy.dist_dir
    code <<-EOH
    . deps/bin/activate
    python setup.py develop
    EOH
end


service "cred_thingy" do
    provider Chef::Provider::Service::Upstart
    supports [:status, :restart]
    subscribes :start, "notify_hub[last_call]"
end

