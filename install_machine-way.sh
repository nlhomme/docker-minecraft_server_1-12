#!/bin/bash

echo ""
echo "Type the minecraft version you want to install"
echo "A list is available at https://minecraft.gamepedia.com/Version_history"
read -r minecraftVersion

#Creation of the folder where the server will run
echo "[0%] Creating the minecraft folder"
mkdir /opt/minecraft
echo "Done!"

#Donwnload Minecraft Server
echo "[20%] Downloading minecraft " $minecraftVersion
if ! wget https://s3.amazonaws.com/Minecraft.Download/versions/$minecraftVersion/minecraft_server.$minecraftVersion.jar -P /opt/minecraft/
then
	echo "Download failed. Check if the version number you typed is correct"
	echo "A list is available at https://minecraft.gamepedia.com/Version_history"
	exit 1
else
	echo "Done!"
fi

#Copy files
echo "[40%] Copying files"
cp files/eula.txt /opt/minecraft/eula.txt
cp files/server.properties /opt/minecraft/
cp files/minecraft.service /etc/systemd/system/
cp files/minecraft-cronjob /etc/cron.d/
echo "Done"

#If the "your-save-folder-inside-me" folder contains a save (folder)
#then copy it tp the minecraft folder and enable it in the game
subDirCount=$(find files/your-save-folder-inside-me/* -maxdepth 0 -type d | wc -l)

if [ $subDirCount -eq 1 ]
then
	minecraftSave=$(basename files/your-save-folder-inside-me/*)
	echo "[60%] Save "minecraftSave" found. I'm copying it..."
	cp -r files/your-save-folder-inside-me/$minecraftSave /opt/minecraft
	echo "level-name="$minecraftSave >> /opt/minecraft/server.properties
	echo "motd=Serveur Minecraft "$minecraftVersion >> /opt/minecraft/server.properties
	echo "Done!"	

elif [ $subDirCount -eq 0 ]
then
	echo "[60%] No save folder... You will have a new world"
	echo "level-name=" >> files/server.properties
	echo "motd=Serveur Minecraft >> /opt/minecraft/server.properties

	echo "Done!"
else
	echo "A problem occured: two or more folders insides files/save-folder-inside-me"
	echo "Ensure that there is zero or one folder a run the script again"
exit 1
fi

#Create minecraft user
#Then give it permissions to run minecraft
echo "[80%] Creating a minecraft user then give it permissions to run minecraft"
useradd -M -r -s "/bin/false" minecraft
chown -R minecraft.minecraft /opt/minecraft

#Give execution rights on the cron job
chmod 0644 /etc/cron.d/minecraft-cronjob

echo "[100%] Installation done!"

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

echo "Minecraft has benn installed inside /opt/minecraft"
echo "My work is over, bye bye!"
exit 0
