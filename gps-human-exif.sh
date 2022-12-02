#!/bin/bash
# Createur : zico731
# Date 27/11/2022
# Comment voir exactement ou une photo a ete prise grace aux metadonnees EXIF
# usage : gps-human-exif.sh
# find /mnt/c/Users/paco/Downloads/ -name "*.jpg" -print0| xargs -0 -n1 -l /tmp/gps-human-exif/gps-human-exif.sh  # multiple

photo="${1}"

if [ -z "$photo" ]
then
        echo  -e "\n usage : ${0##*/} <photo_path>\n"
elif [ ! -f "$photo" ] 
then    
        echo "$photo n'existe pas"

else    
        coord=$(exiftool -c "%+ .6f" ${photo} |awk -F: '/GPS Position/ {print $2}'| tr -d ' ')
        if [ -z "$coord" ]
        then 
                echo "$photo ne contient pas de coordonnees gps"
        else
                lat=$(cut -d',' -f1 <<< ${coord})
                lon=$(cut -d',' -f2 <<< ${coord})
                echo -e "${photo} a ete geocalise avec les coordonnees ${coord} correspondant : \n"

                curl -s "https://nominatim.openstreetmap.org/reverse?format=xml&lat=${lat#*\+}&lon=${lon#*\+}"|grep -oP '(?<=result).*(?=</result>)'|cut -d'>' -f2|sed 's/, /\n/g' 

                echo ""
                read -p "Souhaitez-vous visualiser sur une carte (o/N)? " reponse
                [ "$reponse" == "o" ] && sensible-browser "http://geo.klein-computing.de/gpx_tool.html#${lat},${lon}" 2>/dev/null
	fi      
fi
