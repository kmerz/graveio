Chef::Log.info("[Customising: /etc/motd.tail]")
template "/etc/motd.tail" do
  source "motd.tail"
  mode "0644"
  owner "root"
  group "root"
end
