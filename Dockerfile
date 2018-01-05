##
# NAME             : minecraft
# TO_BUILD         : docker build --build-arg version=[VERSION DU SERVEUR] -t serveurminecraft:latest .
# TO_RUN           : docker run -d --name minecraft -p 25565:25565 serveurminecraft:latest
##

FROM openjdk:8-jre
ARG version
RUN echo $version

#Install rsync and cron
RUN apt-get update && apt-get -y install rsync cron

#Creation of the folder where the server will run
RUN mkdir /opt/minecraft
WORKDIR /opt/minecraft

#Donwnload Minecraft Server
RUN wget https://s3.amazonaws.com/Minecraft.Download/versions/$version/minecraft_server.$version.jar ; mv minecraft_server.$version.jar ./minecraft_server.jar

#Copy files / Copy your save in "files/your-save-folder-inside-me" if u want to use it!!!
ADD files/eula.txt .
ADD files/server.properties .
ADD files/your-save-folder-inside-me ./save/
ADD files/minecraft-cronjob /etc/cron.d/

#Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/minecraft-cronjob

#Start minecraft
VOLUME /opt/minecraft/
ENTRYPOINT ["java", "-Xms1536M", "-Xmx1536M", "-jar", "/opt/minecraft/minecraft_server.jar", "nogui"]
EXPOSE 25565

#Add your save to the server
#Use the script : save.sh
