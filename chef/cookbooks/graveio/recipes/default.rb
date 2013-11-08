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
].each do |p|
  package p
end

Chef::Log.info("[Running: gem install bundler]")
gem_package "bundler" do
  options(:prerelease => true, :format_executable => false)
end
