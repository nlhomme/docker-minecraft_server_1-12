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

#Create minecraft user
#Then give it permissions to run linecraft
useradd -M -r -s "/bin/false" minecraft
chown -R minecraft.minecraft /opt/minecraft

#Give execution rights on the cron job
chmod 0644 /etc/cron.d/minecraft-cronjob

echo "Installation done!"

echo "Do you want to start the minecraft server at boot? (y/N)"
	read -r enable
	if [[ "$enable" = "y" ]]
	then
		systemctl enable minecraft.service
	fi

echo "Do you want to start the minecraft server right now? (y/N)"
	read -r enable
	if [[ "$enable" = "y" ]]
	then
		systemctl daemon-reload
		systemctl start minecraft.service
		#Wait 2 seconds, then check the minecraft server is running
		sleep 2
		if [[ $(systemctl is-active minecraft) = "active" ]]
		then
			echo "Minecraft is running. Have fun!"
		else
			echo "Startup has failed. Run 'journalctl -u minecraft' to see what happened"
			exit 1
		fi

	else
	echo "OK. You can do this later by running this command:"
	echo "systemctl start minecraft.service"
	fi

echo "My work is over, bye bye!"
exit 0
