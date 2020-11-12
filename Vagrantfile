

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
  
  #mount folders
  config.vm.synced_folder "E:\\Work\\Projects\\hybris-2005\\hybris", "/tmp/hybris",
    id: "hybris"
  config.vm.synced_folder "E:\\Work\\Projects\\hybris-2005\\spartacus", "/tmp/spartacusStore",
    id: "spartacus"

  #VM config (name, memory, cpu..)
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
  
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus = 4
    vb.name = 'Sparatucs2'
    #Enabling multiple cores
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
    #Enable symnloc links
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end
  
  config.vm.provision "file", source: "./local.properties", destination: "$HOME/local.properties"
  config.vm.provision "file", source: "./localextensions.xml", destination: "$HOME/localextensions.xml"
  config.vm.provision "file", source: "./mysql-connector-java-8.0.22.jar", destination: "$HOME/mysql-connector-java-8.0.22.jar"
  config.vm.provision "file", source: "./app.module.ts", destination: "$HOME/app.module.ts"
  config.vm.provision "file", source: "./spartacussampledataaddon.zip", destination: "$HOME/spartacussampledataaddon.zip"
  config.vm.provision "file", source: "./yb2bacceleratorstorefront.zip", destination: "$HOME/yb2bacceleratorstorefront.zip"
  config.vm.provision "file", source: "./hybris2005.zip", destination: "$HOME/hybris2005.zip"
  config.vm.provision "file", source: "./sys_master.zip", destination: "$HOME/sys_master.zip"
  config.vm.provision :shell, :path => "vagrant-cx-spartacus-vm-init.sh", :args => "#{ARGV.join(" ")}"
  
end
