# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "chef/centos-7.0"
  config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = true
     vb.memory = "1024"
  end

  config.vm.provision "shell", path: "epel_install.sh"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end

end
