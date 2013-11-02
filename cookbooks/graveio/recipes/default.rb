Chef::Log.info("[Installing: graveio package dependencies]")
[
  'build-essential',
  'g++',
  'make',
  'python',
  'python-software-properties',
  'sqlite3',
  'libicu-dev',
  'nodejs',
].each do |p|
  package p
end

Chef::Log.info("[Running: gem install bundler]")
gem_package "bundler" do
  options(:prerelease => true, :format_executable => false)
end
