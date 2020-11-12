

Vagrant.configure("2") do |config|
  
  config.vm.box = "bento/ubuntu-20.04"

  #Hybris ports
  config.vm.network "forwarded_port", guest: 9002, host: 9002, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 9001, host: 9001, host_ip: "127.0.0.1"
  #debug port
  config.vm.network "forwarded_port", guest: 8000, host: 8000, host_ip: "127.0.0.1"
  #MySQL port
  config.vm.network "forwarded_port", guest: 3306, host: 9306, host_ip: "127.0.0.1"
  #solr
  config.vm.network "forwarded_port", guest: 8983, host: 9983, host_ip: "127.0.0.1"
  #angular
  config.vm.network "forwarded_port", guest: 4200, host: 4200, host_ip: "127.0.0.1" 
  
  
  config.vm.synced_folder "E:\\Work\\Projects\\hybris2005\\hybris", "/tmp/hybris",
    id: "hybris"
  config.vm.synced_folder "E:\\Work\\Projects\\spartacus2\\vagrantSpartacusStore", "/tmp/spartacusStore",
    id: "spartacus"
  #will be used to import mysql dump
  config.vm.synced_folder ".", "/tmp/projectHome",
    id: "currentFolder"


  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
  
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus = 4
    vb.name = 'Sparatucs'
    #Enabling multiple cores
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end
  
  config.vm.provision "file", source: "./local.properties", destination: "$HOME/local.properties"
  config.vm.provision "file", source: "./localextensions.xml", destination: "$HOME/localextensions.xml"
  config.vm.provision "file", source: "./mysql-connector-java-8.0.22.jar", destination: "$HOME/mysql-connector-java-8.0.22.jar"
  config.vm.provision "file", source: "./app.module.ts", destination: "$HOME/app.module.ts"
  config.vm.provision :shell, :path => "vagrant-cx-spartacus-vm-init.sh", :args => "#{ARGV.join(" ")}"
  
end
