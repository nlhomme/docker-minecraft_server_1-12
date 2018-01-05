#!/bin/bash
#Set Realmname to enable save compatibility
nbsvg=$(find /var/lib/docker/volumes/minecraft_saveminecraft/_data/save/* -maxdepth 0 -type d 2>/dev/null | wc -l)
if [[ $nbsvg -eq 0 ]]
then
	read -pr "Thanks to set a name for your new Realm." realmname
elif [[ $nbsvg -eq 1 ]]
then
	realmname="$(find /var/lib/docker/volumes/minecraft_saveminecraft/_data/save/* -maxdepth 0 -type d)"
	echo "Save found in the directory : $realmname"
else [[ $nbsvg -gt 1 ]]
	realmname="$(find /var/lib/docker/volumes/minecraft_saveminecraft/_data/save/* -maxdepth 0 -type d)"
	clear
	echo "Saves found : $realmname"
	read -pr "Thanks to choose the good save : " realmname
fi
#Recuperation du nom de la sauvegarde
nbtour=$(echo "$realmname" | grep -o / | wc -l)
i=0
realmname=$(echo "$realmname" | 
while [[ $i -ne $nbtour ]]
do sed "s/^.*\///"
i=$(($i+1))
done)
#Ajout des paramètres de la sauvegarde
sed -i "30c level-name=$realmname" /var/lib/docker/volumes/minecraft_saveminecraft/_data/server.properties
cd /var/lib/docker/volumes/minecraft_saveminecraft/_data/
ln -s ./save/"$realmname" "$realmname"
cd -
docker-compose restart minecraft
