# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.hostname = "graveio-dev"
  config.vm.network :forwarded_port, guest: 3000, host: 3000

  config.vm.provider "virtualbox" do |v|
    v.name = "graveio-dev"
  end

  config.ssh.forward_agent = true

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "proxy"
    chef.add_recipe "apt"
    chef.add_recipe "etc"
    chef.add_recipe "graveio"
  end

end
