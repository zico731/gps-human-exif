# gps-human-exif.sh #

Comment voir exactement où une photo a été prise grâce aux metadonnées EXIF  
Traduit les coordonnées gps d'une photo géolocalisée en localisation lisible (numéro de rue, rue, ville, département, pays)

## usage ##  
gps-human-exif-sh  \<photo_path\>  
  
### traitement en masse sur des images 
find /mnt/c/Users/zico731/Downloads/ -name "*.jpg" -print0 | xargs -0 -n1 -l /tmp/gps-human-exif/gps-human-exif.sh
