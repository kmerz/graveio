desc "Install node dependencies"
task :install_node_modules do
  system('npm install jshint')
end
