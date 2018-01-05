#!/bin/bash
#Set Realmname to enable save compatibility
nbsvg=$(find /var/lib/docker/volumes/saveminecraft/_data/save/ -type d | wc -l)
if [[ $nbsvg -eq 0 ]]
then
	read -p "Thanks to set a name for your new Realm." realmname
elif [[ $nbsvg -eq 1 ]]
then
	realmname=$(ls -l /var/lib/docker/volumes/saveminecraft/_data/save/ | awk '{print $1}')
	echo "Save found in the directory : "$realmname
else [[ $nbsvg -gt 1 ]]
	realmname=$(ls -l /var/lib/docker/volumes/saveminecraft/_data/save/ | awk '{print $1}')
	clear
	echo "Saves found : "$realmname
	read -p "Thanks to choose the good save : " realmname
fi
sed "/30/c level-name=$realmname" /var/lib/docker/volumes/saveminecraft/_data/server.properties
docker-compose restart minecraft
