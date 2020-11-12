Vagrant-Spartacus
==============

The project aims to fast set up a dev environment for those who want to learn SAP Spartacus.
Please follow the steps bellow to set up the box

Prerequisite
==============
SAP Commerce 2005 Zip
Oracle VM VirtualBox

Installation - Config
==============
- Unzip SAP Commerce 2005 Zip
- create a folder an name it as you want, note that folder will contain Sparatucs files
- Mount SAP folder with Vagrant folder, to do that :
-- Open Vagrantfile
-- Replace the path : replace **[SAP_COMMERCE_PATH]** with your SAP Commerce 2005
```sh
config.vm.synced_folder "[SAP_COMMERCE_PATH]", "/tmp/hybris",
    id: "hybris"
```
- Mount Spartacus folder with Vagrant folder, to do that :
-- Open Vagrantfile
-- Replace the path : replace **[SPARTACUS_PATH]** with your the path of the folder that you have created before
```sh
config.vm.synced_folder "[SPARTACUS_PATH]", "/tmp/spartacusStore",
    id: "spartacus"
```
- Start the box :
```sh
vagrant --initAll up --provision
```
(Note : all vagrant command line should be executed from the folder which contains source files)
- Build & start Hybris  :
```sh
#access to the box
vagrant ssh
#set ant env
cd /tmp/hybris/bin/platform
. ./setantenv.sh
#generate hybris folders ( config, data,log..)
ant
#exit the box
exit
#reload the box to import medias & continue the installation
vagrant --importMedias --setConfig reload --provision
#set ant env
cd /tmp/hybris/bin/platform
. ./setantenv.sh
#run clean all
ant clean all
#start Hybris
./hybrisserver.sh
```
- Build & start Spartacus
```sh
#access to the box in a new shell ( keep that for hybris open )
vagrant ssh
cd /tmp/spartacusStore
#start Sparatcus
sudo yarn start --host 0.0.0.0 --port 4200 
```
### Important : 
All vagrant commands line should be executed as admin if you are a Windows user 

### Notes
- You can run hybris in debug mode, so you can debug from the host on port 8000, you just need to run the hybris server in debug mode :
```sh
./hybrisserver.sh debug 
```
- The sparatacus files are generated in the host machine, so you can create your own angualr components or customize Spartacus ones ;)
