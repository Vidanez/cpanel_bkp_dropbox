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

USERNAME=
PASSWORD=
VPS=
TIMEOUT=

# Borrar Backup viejos
echo "Borrando backup viejos"
rm -f /home/$USERNAME/backup*.tar.gz

#Generar backup
echo "Llamando a backupwizard"
wget -O /dev/null --http-user=$USERNAME --http-password=$PASSWORD https://$VPS:2083/frontend/x3/backup/wizard-dofullbackup.html --auth-no-challenge --post-data="dest=homedir&email=antoniogameznieto@gmail.com" --no-check-certificate
if [ "$?" -gt "0" ]; then
    echo "FAILED calling backup wizard. Check configuration";
fi

# Esperar que el backup se genere
for {set x 1} {$x<=$TIMEOUT} {set x [expr {$x + 1}]} {
  NUMFILES=$(ls /home/$USERNAME/backup*.tar.gz | wc -l) > /dev/null 2>&1
  case $NUMFILES in
      0)
          DATE=`date +%Y-%m-%d:%H:%M:%S`
          echo "Esperando a que se termine el backup"
          echo $DATE
          sleep 5
      ;;
      1)
	  echo "Backup listo"
          DATE=`date +%Y-%m-%d:%H:%M:%S`
          echo $DATE
          FILE=$(ls /home/$USERNAME/backup*.tar.gz)
          echo $FILE
          break
      ;;
      *)
	  echo "Hay mas de un backup en el directorio borrelos y comience de nuevo"
          break
      ;;
  esac
}

#Subiendo el fichero
/home/$USERNAME/scripts/dropbox_uploader.sh -q upload $FILE $FILE > /dev/null 2>&1
rm -f $FILE
