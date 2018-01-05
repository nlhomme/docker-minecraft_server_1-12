#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi



###START
echo ""
echo "Hello, welcome to the Minecraft Server for dummies installation wizard!"
echo "Which way do you want to install Minecraft Server:"
echo "1) Inside a Docker container?"
echo "2) Directly on your machine?"
echo ""
echo "Type 1 or 2 to answer"

read -r way

if [[ "$way" = "1" ]]
then
	echo "You have selected the Docker way. Are you sure? (y/N)"
	read -r sure
	if [[ "$sure" = "y" ]]
	then
		./install_docker-way.sh
	

	else	
		echo "Aborting"
		exit 0
	fi

elif [[ "$way" = "2" ]]
then
	echo "You have selected the machine way. Are you sure? (y/N)"
	read -r sure
	if [[ "$sure" = "y" ]]
	then
		./install_machine-way.sh
	else	
		echo "Aborting"
		exit 0
	fi

else
	printf "invalid answer"
	exit 1
fi
###END###
