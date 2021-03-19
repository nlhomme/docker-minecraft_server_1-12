# Minecraft server for dummies

(Very) Easily install a minecraft server directly on your machine or inside a Docker container

# I started to work on this in 2017. The docker ways is not working due to the switch from Minecraft Vanilla to Spigot, and the download instructions are obsolete
Spigotis awesome. It lets you to run a minecraft server (normal), AND gives you the possibility to install plugins!
Take a look [on their site] (https://www.spigotmc.org/)

# Requirement (Docker part): 
 - Docker Engine 17.09+
 - Docker-compose 1.18.0 (PATH include)
# Requirement (Docker part): 
 - Openjdk-11-jre
# How to make it run:
- Clone the repo (No, really?)
- Store your save folder in "files/your-save-folder-inside-me/" (If you got one)
- Check which minecraft version you want to play at [the Spigot build page](https://www.spigotmc.org/wiki/buildtools/#versions)
- Run setup-wizard.sh as root
- Follow the instructions 
- Play!
