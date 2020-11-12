#################################
#  Bash params for building env #
#################################
#get bash params
initAll=false
buildSpartacus=false
for var in "$@"
do
    if [ "$var" = "--initAll" ];then
        initAll=true
    fi
    if [ "$var" = "--buildSpartacus" ];then
        buildSpartacus=true
    fi
done

############### INIT ALL : BEGIN ####################
if [ "$initAll" = true ]; then
    #################################
    #    Setting up Docker Repo     #
    #################################
    #all following steps is for setup repo
    #Update the apt package index and install packages to allow apt to use a repository over HTTPS:
    sudo apt-get -y update
    sudo apt-get -y install apt-transport-https
    sudo apt-get -y install ca-certificates
    sudo apt-get -y install curl 
    sudo apt-get -y install gnupg-agent
    sudo apt-get -y install software-properties-common
    #Add Docker’s official GPG key:
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    #set up the stable repository
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs) exist stable"
    echo "SET UP REPO DONE"
    echo "INSTALL DOCKER ENGINE.."
    sudo apt-get -y update
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io

    #################################
    #  Setting up needed programs   #
    ################################# 
    #intsall java11
    sudo apt-get -y update
    sudo apt -y install openjdk-11-jdk
    #install nodejs
    sudo apt -y update
    sudo apt -y install nodejs npm
    #install yarn
    sudo curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt -y update
    sudo apt -y install --no-install-recommends yarn
    #intstall angular
    sudo npm install -g @angular/cli@9.1.1
fi
############### INIT ALL : END ####################

#################################
#     Hybris config             #
#################################
#rename local.properties on host an keep it, if the file already exist don't rename it again
LOCAL_PROPERTIES_HOST_FILE="/tmp/hybris/config/local-host.properties"
if [ ! -f "$LOCAL_PROPERTIES_HOST_FILE" ]; then
    sudo mv /tmp/hybris/config/local.properties $LOCAL_PROPERTIES_HOST_FILE
fi
#move local.properties attached to this projet to Hybris config dir
sudo mv /home/vagrant/local.properties /tmp/hybris/config/local.properties

#do the same with localextensions
LOCAL_EXTENSIONS_HOST_FILE="/tmp/hybris/config/localextensions-host.xml"
if [ ! -f "$LOCAL_EXTENSIONS_HOST_FILE" ]; then
    sudo mv /tmp/hybris/config/localextensions.xml $LOCAL_PROPERTIES_HOST_FILE
fi
#move localextensions.xml attached to this projet to Hybris config dir
sudo mv /home/vagrant/localextensions.xml /tmp/hybris/config/localextensions.xml


#move mysql-connector-java-8.0.22.jar to the lib folder
FILE=/tmp/hybris/bin/platform/lib/dbdriver/mysql-connector-java-8.0.22.jar
if [ ! -f "$FILE" ]; then
    sudo mv /home/vagrant/mysql-connector-java-8.0.22.jar $FILE
fi

#################################
#        Set up Spartacus       #
#################################
#build spartacus project
if [ "$buildSpartacus" = true ]; then
    echo "Building spartacus.."
    cd /tmp
    sudo ng new spartacusStore --style=scss --routing=false --skipGit=true --skip-install
    cd spartacusStore
    sudo yarn install
    sudo ng add @spartacus/schematics
    sudo yarn install
    #replace app.module.ts
    sudo mv /home/vagrant/app.module.ts /tmp/spartacusStore/src/app/app.module.ts
    #start spartacus
    #sudo yarn start --host 0.0.0.0 --port 4200 
fi

#################################
#  MySQL Docker container conf  #
#################################
#config database using docker
#pull mysql docker container
if [ "$(sudo docker image ls | grep mysql)" ]; then
	echo "mysql image already exists"
else
    echo "downloading mysql image"
	sudo docker pull mysql
fi
#run mysql container
if [ "$(sudo docker ps -a | grep mysqlCntr)" ]; then
	echo "mysql container is present, no need to create it again"
    if [ "$(sudo docker ps -a | grep mysqlCntr | grep Exited)" ]; then
        sudo docker start mysqlCntr
    fi
else
    echo "runing mysql container"
	sudo docker run --name mysqlCntr -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=hybris2005 -d -p 3306:3306  mysql
    cd /tmp/projectHome
    #sleep 1min before importing
    sleep 60
    sudo docker exec -i mysqlCntr mysql -P 3306 -uroot -proot hybris2005 < hybris2005.sql
fi


