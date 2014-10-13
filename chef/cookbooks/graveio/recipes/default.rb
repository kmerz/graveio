Chef::Log.info("[Installing: graveio package dependencies]")
[
  'build-essential',
  'g++',
  'libicu-dev',
  'make',
  'nodejs',
  'python',
  'python-software-properties',
  'sqlite3',
  'vim',
  'tmux',
].each do |p|
  package p
end

Chef::Log.info("[Running: gem install bundler]")
gem_package "bundler" do
  options(:prerelease => true, :format_executable => false)
end

Chef::Log.info("[Installing: bury configuration for User vagrant]")
template "/home/vagrant/.buryrc" do
  source "bury.config"
  mode "0644"
  owner "vagrant"
  group "vagrant"
  action :create_if_missing
end
