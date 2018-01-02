#!/bin/bash

#Creation of the folder where the server will run
mkdir /opt/minecraft

#Donwnload Minecraft Server
wget https://s3.amazonaws.com/Minecraft.Download/versions/1.12/minecraft_server.1.12.jar -P /opt/minecraft/

#Copy files
cp files/eula.txt /opt/minecraft/eula.txt
cp files/server.properties /opt/minecraft/
cp files/minecraft.service /etc/systemd/system/
cp files/minecraft-cronjob /etc/cron.d/

#CRER UTILISATEUR MINECRAFT###
groupadd -r minecraft
useradd -M -r -g minecraft -s "/bin/bash" minecraft

#Give execution rights on the cron job
chmod 0644 /etc/cron.d/minecraft-cronjob

echo "Installation done!"

echo "Do you want to start the minecraft server at boot?"
	read -r enable
	if [[ "$enable" = "y" ]]
	then
		systemctl enable minecraft.service
	fi

echo "Do you want to start the minecraft server right now?"
	read -r enable
	if [[ "$enable" = "y" ]]
	then
		systemctl start minecraft.service
	else
	echo "You can do this later by running this command:"
	echo "systemctl start minecraft.service"
	fi

exit 0
