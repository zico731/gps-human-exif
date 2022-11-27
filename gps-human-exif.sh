
photo=$1
[[ -z $1 ]] && (echo  -e "\n usage : ${0##*/} <photo_path>\n";exit 1)
coord=$(exiftool -c "%+ .6f" ${photo} |awk -F: '/GPS Position/ {print $2}'| tr -d ' +'| tr ',' ' ') && read lat lon <<< "$coord"
curl -s "https://nominatim.openstreetmap.org/reverse?format=xml&lat=${lat}&lon=${lon}"|grep -oP '(?<=result).*(?=</result>)'|cut -d'>' -f2|sed 's/, /\n/g' 
