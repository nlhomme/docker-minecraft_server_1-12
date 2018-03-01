#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

###START###
echo ""
echo "Hi! Welcome to the removal wizard!"
echo ""
echo "This will erase all your minecraft installation, including your save. You should backup it first..."
echo "Are you sure you want to do this? (y/n)"

read -r sure

if [[ "$sure" = "y" ]]
then
	#By safety, the removal script stops if Minecraft server is running
	if [[ $(systemctl is-active minecraft) = "active" ]]
	then
		echo "Minecraft is running. Stop it yourself before removing"
		exit 1
	fi

	#Let's remove!
	echo "[0%] Removing Minecraft folder..."
	if ! rm -rf /opt/minecraft
	then
		echo "WARNING: This operation failed"
	else
		echo "Done!"
	fi

	echo "[25%] Removing the systemd service..."
	if ! rm /etc/systemd/system/minecraft.service
	then
		echo "WARNING: This operation failed"
	else
		echo "Done!"
	fi

	echo "[50%] Removing the save cron job..."
	if ! rm /etc/cron.d/minecraft-cronjob
	then
		echo "WARNING: This operation failed"
	else
		echo "Done!"
	fi


	echo "[75%] Removing the minecraft user..."
	if ! userdel minecraft
	then
		echo "WARNING: This operation failed"
	else
		echo "Done!"
	fi

	echo "[99%] Reloading systemctl..."
	if ! systemctl daemon-reload
	then
		echo "WARNING: This operation failed"
	else
		echo "Done!"
	fi

#If the user is not sure, aborting
elif [[ "$sure" = "n" ]]
then
	echo "You are wise. Aborting..."
	exit 0
fi

#Work is done
echo "[100%] My work is done. Bye bye!"
exit 0
###END###
