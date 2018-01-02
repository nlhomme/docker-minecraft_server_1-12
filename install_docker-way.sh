#!/bin/bash

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

#Now let's build the container
docker build --rm -t nlhomme/minecraft_server-fordummies:latest .

#If the build has failed, exit with error code			
#if $
echo "Your minecraft docker inside docker is ready! To run it, type:"
echo "docker run -t -v /mnt/minecraft:/opt/minecraft/ -p 25565:25565 nlhomme/minecraft_server-fordummies:latest"		

exit 0

