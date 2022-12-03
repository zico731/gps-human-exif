#!/bin/bash
# Createur : zico731
# Date 27/11/2022
# Comment voir exactement ou une photo a ete prise grace aux metadonnees EXIF
# usage : gps-human-exif.sh
# find /mnt/c/Users/paco/Downloads/ -name "*.jpg" -print0| xargs -0 -n1 -l /tmp/gps-human-exif/gps-human-exif.sh  # multiple

# on assigne dans une variable le chemin de la photo
photo="${1}"

# afficher l'USAGE s'il y a aucun argument
if [ -z "$photo" ]
then
        echo  -e "\n usage : ${0##*/} <photo_path>\n"

# affichage d'erreur si le fichier n'existe pas
elif [ ! -f "$photo" ] 
then    
        echo "$photo n'existe pas"

else    

# extration des coordonnées GPS au bon format
        coord=$(exiftool -c "%+ .6f" "${photo}" |awk -F: '/GPS Position/ {print $2}'| tr -d ' ')

# si absence de coordonnées GPS afficher message
        if [ -z "$coord" ]
        then 
                echo "$photo ne contient pas de coordonnees gps"
        else

# extraction de la latitude dans une variable
                lat=$(cut -d',' -f1 <<< "${coord}")

# extraction de la longitudedans une variable
                lon=$(cut -d',' -f2 <<< "${coord}")

                echo -e "${photo} a ete geocalise avec les coordonnees ${coord} correspondant : \n"

# on renseigne la latitude et longitude dans l'API pour extraire et afficher les coordonnées sous forme littérale
                curl -s "https://nominatim.openstreetmap.org/reverse?format=xml&lat=${lat#*\+}&lon=${lon#*\+}"|grep -oP '(?<=result).*(?=</result>)'|cut -d'>' -f2|sed 's/, /\n/g' 

                echo ""

# souhaitons-nous visualiser sur une carte, si oui on renseigne la latitude et longitude dans l'API cartographique
                read -rp "Souhaitez-vous visualiser sur une carte (o/N)? " reponse

# on ouvre le navigateur web puis on affiche la carte
                [ "$reponse" == "o" ] && sensible-browser "http://geo.klein-computing.de/gpx_tool.html#${lat},${lon}" 2>/dev/null
	fi      
fi
