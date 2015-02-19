# -*- mode: ruby -*-
# vi: set ft=ruby :


VAGRANT_ROOT = File.dirname(File.expand_path(__FILE__))
file_to_disk = File.join(VAGRANT_ROOT, 'disk2.vdi')

vagrant_id=`cat .vagrant/machines/foreman/virtualbox/id`

sata_controller = 'SATA Controller'

Vagrant.configure(2) do |config|


  if Vagrant.has_plugin?("vagrant-cachier")
    # Configure cached packages to be shared between instances of the same base box.
    # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
    config.cache.scope = :box

    # OPTIONAL: If you are using VirtualBox, you might want to use that to enable
    # NFS for shared folders. This is also very useful for vagrant-libvirt if you
    # want bi-directional sync
    #config.cache.synced_folder_opts = {
    #  type: :nfs,
      # The nolock option can be useful for an NFSv3 client that wants to avoid the
      # NLM sideband protocol. Without this option, apt-get might hang if it tries
      # to lock files needed for /var/cache/* operations. All of this can be avoided
      # by using NFSv4 everywhere. Please note that the tcp option is not the default.
    #  mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    #}
    # For more information please check http://docs.vagrantup.com/v2/synced-folders/basic_usage.html
  end  

  #config.vm.box = "chef/centos-7.0"

  config.vm.define "freeipa" do |freeipa|

     freeipa.vm.provider "virtualbox" do |vb|
        vb.memory = "1536"
     end
     freeipa.vm.box = "chef/centos-7.0"
     freeipa.vm.network :private_network, :ip => "192.168.33.50"

     freeipa.vm.provision "shell", path: "freeipa/bootstrap.sh", args: "server"
  end

  config.vm.define "replica" do |freeipa|

     freeipa.vm.provider "virtualbox" do |vb|
        vb.memory = "1024"
     end
     freeipa.vm.box = "chef/centos-7.0"
     freeipa.vm.network :private_network, :ip => "192.168.33.60"

     freeipa.vm.provision "ansible" do |ansible|
        ansible.playbook = "freeipa/playbook.yml"
     end
     freeipa.vm.provision "puppet" do |puppet|
        puppet.manifest_file = "replica.pp"
        puppet.module_path = "modules"
     end
     freeipa.vm.provision "shell", path: "freeipa/bootstrap.sh", args: "replica"
  end


  config.vm.define "foreman" do |foreman|

     foreman.vm.box = "centos6"

     foreman.vm.provider "virtualbox" do |vb|
         vb.gui = true
         vb.memory = "1536"
         vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

         unless File.exist?(file_to_disk)
            vb.customize ['createhd', '--filename', file_to_disk, '--size', 500 * 1024]
         end
        puts vagrant_id
        disk2_attached = `VBoxManage showvminfo #{vagrant_id} | grep -c disk2.vdi`.to_i
        if disk2_attached == 0
         puts "attaching disk2"
         vb.customize ["storagectl", :id, "--name", "#{sata_controller}", "--add", "sata"] 
         vb.customize ['storageattach', :id, '--storagectl', sata_controller, '--port', 2, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
        else
          puts "disk2 already attached"
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

