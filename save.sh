#!/bin/bash
#Set Realmname to enable save compatibility
nbsvg=$(find /var/lib/docker/volumes/minecraft_saveminecraft/_data/save/* -maxdepth 0 -type d 2>/dev/null | wc -l)
if [[ $nbsvg -eq 0 ]]
then
        read -p "Thanks to set a name for your new Realm." realmname
elif [[ $nbsvg -eq 1 ]]
then
        realmname=$(find /var/lib/docker/volumes/minecraft_saveminecraft/_data/save/* -maxdepth 0 -type d | awk '{print $1}')
        echo "Save found in the directory : "$realmname
else [[ $nbsvg -gt 1 ]]
        realmname=i$(find /var/lib/docker/volumes/minecraft_saveminecraft/_data/save/* -maxdepth 0 -type d | awk '{print $1}')
        clear
        echo "Saves found : "$realmname
        read -p "Thanks to choose the good save : " realmname
fi
sed "/30/c level-name=$realmname" /var/lib/docker/volumes/minecraft_saveminecraft/_data/server.properties
docker-compose restart minecraft