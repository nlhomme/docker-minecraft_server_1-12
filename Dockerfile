##
# NAME             : nlhomme/minecraft_server-fordummies
# TO_BUILD         : docker build --rm -t nlhomme/minecraft_server-fordummies:lastest .
# TO_RUN           : docker run -t -p 25565:25565 nlhomme/minecraft_server-fordummies:lastest
##

FROM openjdk:8-jre

#Install rsync and cron
RUN apt-get update && apt-get -y install rsync cron

#Creation of the folder where the server will run
RUN mkdir /opt/minecraft
WORKDIR /opt/minecraft

#Donwnload Minecraft Server
RUN wget https://s3.amazonaws.com/Minecraft.Download/versions/1.12/minecraft_server.1.12.jar

#Copy files
ADD files/eula.txt .
ADD files/server.properties .
ADD files/minecraft-cronjob /etc/cron.d/

#Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/minecraft-cronjob

#Start minecraft
CMD java -Xms1536M -Xmx1536M -jar /opt/minecraft/minecraft_server.1.12.jar nogui

EXPOSE 25565
