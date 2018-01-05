#Set Realmname to enable save compatibility
nbsvg=$(find /opt/minecraft/save -type d | wc -l)
if [[ $nbsvg -eq 0 ]]
then
	read -p "Thanks to set a name for your new Realm." realmname
elif [[ $nbsvg -eq 1 ]]
then
	realname=$(ls -l ./save/ | awk '{print $1}')
	echo "Save found in the directory : "$realmname
else [[ $nbsvg -gt 1 ]]
	realname=$(ls -l ./save/ | awk '{print $1}')
	clear
	echo "Saves found : "$realmname
	read -p "Thanks to choose the good save : " realmname
fi
sed "/30/c level-name=$realmname" server.properties
