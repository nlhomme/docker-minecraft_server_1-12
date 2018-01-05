#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

###START###
echo ""
echo "Hi! Welcome to the removal wizard!"
echo ""
echo "This will erase all your minecraft container, including your save. You should backup it first..."
echo "Are you sure you want to do this? (y/n)"

read -r sure

if [[ "$sure" = "y" ]]
then
        ##If the container is already running, stop it automatically
        docker-compose down
        docker volume rm minecraft_saveminecraft
        docker rmi serveurminecraft

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