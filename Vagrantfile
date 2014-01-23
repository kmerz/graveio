# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.hostname = "graveio-dev"
  config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :private_network, ip: "192.168.10.10"

  config.vm.provider "virtualbox" do |v|
    v.name = "graveio-dev"
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.ssh.forward_agent = true

  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "chef/cookbooks"
    chef.add_recipe "proxy"
    chef.add_recipe "apt"
    chef.add_recipe "etc"
    chef.add_recipe "graveio"
    chef.add_recipe "rvm::system"
    chef.add_recipe "rvm::vagrant"

    chef.json = {
      :rvm => {
        :version => "1.17.10",
        :rubies => ["ruby-1.9.3-head"],
        :default_ruby => "ruby-1.9.3-head",
      }
    }

  end

end
