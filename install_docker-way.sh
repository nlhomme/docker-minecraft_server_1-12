#!/bin/bash
#TO DO : Ajout le contrôle systemctl enable de docker
if [[ $(systemctl is-enabled docker | echo $? ) -eq 0 ]]
then
	echo "Docker is enabled."
else
	systemctl enable docker
	if [[ $(echo $?) -eq 0 ]]
	then
		echo "Docker was inactive. That's ok now."
	else
		echo "Docker isn't installed. Please install it."
		exit 1
	fi
fi
#Starting the docker service if it is inactive
if [[ $(systemctl is-active docker) = "active" ]]
then
	echo "Docker is running. Great!"
else
	echo "Docker isn't running. I'm starting it for you"
	systemctl start docker
fi
#Test de la présence de docker-compose
if [ -x /usr/local/bin/docker-compose ]
then
	echo "docker-compose is already installed"
else 
	echo "docker-compose needs to be on your system to go through, please install it."
	exit 1
fi
read -p "Please enter the desired minecraft version." version
sed -i "8c \ \ \ \ \ \ \ \ version: $version" docker-compose.yml
#Now let's build the container
docker-compose up -d 
if [[ $? = 0 ]] 
then
	echo "Server is running."
	echo "Save script :"
	./save.sh
else
	echo "La mise en service du conteneur a rencontré un problème."
	echo "A problem occured during the startup of the conatainer"
	exit 1
fi
exit 0
