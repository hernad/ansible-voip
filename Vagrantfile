# -*- mode: ruby -*-
# vi: set ft=ruby :


VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))
file_to_disk = File.join(VAGRANT_ROOT, 'disk2.vdi')

sata_controller = 'SATA Controller'


Vagrant.configure(2) do |config|
  config.vm.box = "chef/centos-7.0"
  config.vm.provider "virtualbox" do |vb|
     vb.gui = true
     vb.memory = "1024"

     unless File.exist?(file_to_disk)
         vb.customize ['createhd', '--filename', file_to_disk, '--size', 500 * 1024]
     end

     #vb.customize ["storagectl", :id, "--name", "#{sata_controller}", "--add", "sata"]
     vb.customize ['storageattach', :id, '--storagectl', sata_controller, '--port', 2, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
  end


  config.vm.provision "shell", path: "epel_install.sh"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end

end
