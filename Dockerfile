##
# NAME             : nlhomme/docker-minecraft_server_1-12
# TO_BUILD         : docker build --rm -t nlhomme/docker-minecraft_server_1-12:latest .
# TO_RUN           : docker run -v /mnt/minecraft:/opt/minecraft/ -p 25565:25565 nlhomme/docker-minecraft_server_1-12:latest 
##

FROM openjdk:8-jre

#Check/Install rsync, just in case
RUN apt-get install rsync

#Creation of the folder where the server will run
RUN mkdir /opt/minecraft

#Copy files
ADD files/eula.txt /opt/minecraft/eula.txt
ADD files/minecraft_server.1.12.jar /opt/minecraft/
ADD files/server.properties /opt/minecraft/
ADD files/minecraft.service /etc/systemd/system/
ADD files/rsync-minecraft /opt/minecraft/

#Make the backup script executable
RUN chmod +x /opt/minecraft/rsync-minecraft

#Create the cron job to backup minecraft every hour
RUN crontab -l > mycron && \
    echo "0*/1 * * * sh /opt/minecraft/rsync-minecraft" >> mycron && \
    rm mycron

#Start minecraft
RUN systemctl enable minecraft.service

EXPOSE 25565
