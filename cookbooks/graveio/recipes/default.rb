Chef::Log.info("Installing: graveio package dependencies]")
[
  'build-essential',
  'libicu-dev',
  'sqlite3',
].each do |p|
  package p
end
