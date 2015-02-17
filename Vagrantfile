# -*- mode: ruby -*-
# vi: set ft=ruby :


VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))
file_to_disk = File.join(VAGRANT_ROOT, 'disk2.vdi')

disk2_attached = `VBoxManage showvminfo \`cat .vagrant/machines/foreman/virtualbox/id\` | grep -c disk2.vdi`.to_i

puts "disk2 attached: #{disk2_attached}"

sata_controller = 'SATA Controller'


Vagrant.configure(2) do |config|
  

  config.vm.box = "chef/centos-7.0"


  config.vm.define "foreman" do |foreman|

     foreman.vm.provider "virtualbox" do |vb|
         vb.gui = true
         vb.memory = "1536"
         vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

         unless File.exist?(file_to_disk)
            vb.customize ['createhd', '--filename', file_to_disk, '--size', 500 * 1024]
         end

        if not disk2_attached
         vb.customize ["storagectl", :id, "--name", "#{sata_controller}", "--add", "sata"] 
         vb.customize ['storageattach', :id, '--storagectl', sata_controller, '--port', 2, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
        end
     end

     foreman.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook-foreman.yml"
     end
     foreman.vm.provision "puppet" do |puppet|
        puppet.manifest_file = "foreman.pp"
        puppet.module_path = "modules"
     end

     foreman.vm.provision "shell", path: "bootstrap.sh"

     foreman.vm.network :private_network, :ip => "192.168.33.51"

  end
end

