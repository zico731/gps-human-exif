#!/bin/bash
# Créateur : zico731
# Date 27/11/2022
# Comment voir exactement où une photo a été prise grâce aux metadonnées EXIF
# usage : gps-human-exif.sh
#         find /mnt/c/Users/paco/Downloads/ -name "*.jpg" -print0| xargs -0 -n1 -l /tmp/gps-human-exif/gps-human-exif.sh  # multiple

photo="${1}"
[[ -z "$1" ]] && (echo  -e "\n usage : ${0##*/} <photo_path>\n";exit 1)
echo "${photo}"
coord=$(exiftool -c "%+ .6f" "${photo}" |awk -F: '/GPS Position/ {print $2}'| tr -d ' +'| tr ',' ' ') && read lat lon <<< "$coord"
curl -s "https://nominatim.openstreetmap.org/reverse?format=xml&lat=${lat}&lon=${lon}"|grep -oP '(?<=result).*(?=</result>)'|cut -d'>' -f2|sed 's/, /\n/g' 
echo ""

