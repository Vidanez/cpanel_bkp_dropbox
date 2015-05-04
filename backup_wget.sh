#!/bin/bash
#
# Script para lanzar en un cron job para crear un backup que se deposita en el home folder del usuario
# Una vez creado el backup se empuja a la cuenta de dropbox habilitada por token y se borra.
#
# Este script ha sido convertido en un binario usando http://www.datsi.fi.upm.es/~frosal/sources/shc.html
#
# Requerimientos: Software
# Posibilidad de ejecutar curl y wget
# https://github.com/andreafabrizi/Dropbox-Uploader configurado con la cuenta de dropbox a usar en cada usuario
# que ejecute este script.
# Al contener este script claves en texto plano se aconseja usar el software shc para convertir en un ejecutable
# binario http://www.datsi.fi.upm.es/~frosal/sources/shc-3.8.9.tgz una vez seguidos los pasos que se detallan en 
# http://www.thegeekstuff.com/2012/05/encrypt-bash-shell-script/ se aconseja borrar los ficheros .C y .sh y 
# unicamente dejar en la cuenta del usuario el .sh.x

# Variables

USERNAME=vidanez
PASSWORD=R7Uugf8HVJ86LQDF
VPS=vps13590.inmotionhosting.com


# Borrar Backup viejos
echo "Borrando backup viejos"
rm -rf /home/$USERNAME/backup*

#Generar backup
echo "LLamando a backupwizard"
wget -O /dev/null --http-user=$USERNAME --http-password=$PASSWORD https://$VPS:2083/frontend/x3/backup/wizard-dofullbackup.html --auth-no-challenge --post-data="dest=homedir&email=antoniogameznieto@gmail.com" --no-check-certificate
if [ "$?" -gt "0" ]; then
    echo "FAILED calling backup wizard. Check configuration";
fi

# Esperar que el backup se genere
while true
do
NUMFILES=$(ls /home/$USERNAME/backup* | wc -l) 2>&1 >> /dev/null
  case $NUMFILES in
      0)
          echo "0 Esperando a que se termine el backup"
          sleep 5
      ;;
      1)
	  echo "Backup listo"
          FILE=$(ls /home/$USERNAME/backup*)
          echo $FILE
          break
      ;;
      2)
	  echo "2 Esperando a que se termine el backup"
          sleep 5
      ;;
      *)
	  echo "Hay mas de un backup en el directorio borrelos y comience de nuevo"
          break
      ;;
  esac
done

#Subiendo el fichero
/home/$USERNAME/bin/dropbox_uploader -d upload $FILE $FILE
rm -rf /home/$USERNAME/backup*

