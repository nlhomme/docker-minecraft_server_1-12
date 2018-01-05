#!/bin/bash
#TO DO : Ajout le contrôle systemctl enable de docker

#Starting the docker service if it is inactive
if [[ $(systemctl is-active docker) = "active" ]]
then
	echo "Docker is running. Great!"

elif [[ $(systemctl is-active docker) = "inactive" ]]
then
	echo "Docker is inactive. I'm starting it for you"
	systemctl start docker
else
	echo "Docker service not found. You should install docker"
	exit 1
fi
#Test de la présence de docker-compose
if [ -x /usr/local/bin/docker-compose ]
then
	echo "docker-compose est installé"
else 
	echo "docker-compose need to be on your system to go through, thanks to install it."
	exit 1
fi
read -p "Please enter the desired minecraft version." version
sed "/8/c         version: $version" docker-compose.yml
#Now let's build the container
docker-compose up -d 
if [[ $? = 0 ]] 
then
	echo "Server is running."
	echo "Save script :"
	./save.sh
else echo "La mise en service du conteneur a rencontré un problème."
fi

exit 0
