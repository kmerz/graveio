desc "Check for javascript syntax"
task :js_syntax => :install_node_modules do
  system('./node_modules/jshint/bin/jshint app/assets/javascripts/*.js')
end
