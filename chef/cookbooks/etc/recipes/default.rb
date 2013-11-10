Chef::Log.info("[Adding Repository: ppa:chris-lea/node.js]")
apt_repository "ppa-nodejs" do
  uri "http://ppa.launchpad.net/chris-lea/node.js/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "B9316A7BC7917B12"
  action :add
end

Chef::Log.info("[Customising: /etc/motd.tail]")
template "/etc/motd.tail" do
  source "motd.tail"
  mode "0644"
  owner "root"
  group "root"
  action :create_if_missing
end
