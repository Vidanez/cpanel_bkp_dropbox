# CPANEL BACKUP TO DROPBOX USING WGET
Cpanel Backup using wget to pull it and dropbox as destination using dropbox uploader. Also ofuscation with SHC


Requirements:

https://github.com/andreafabrizi/Dropbox-Uploader

Installed and configured to use API

In order to avoid to have the password and username in plain text the recommendation is to use the following to obfuscate the code

http://www.datsi.fi.upm.es/~frosal/sources/shc-3.8.9.tgz 

http://www.datsi.fi.upm.es/~frosal/sources/shc.html

http://www.thegeekstuff.com/2012/05/encrypt-bash-shell-script/ 



STEPS:

mkdir /home/$username/scripts

cd /home/$username/scripts

wget https://github.com/Vidanez/cpanel_bkp_dropbox/cpanel_bkp_dropbox/backup_wget.sh

curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh

chmod 755 dropbox_uploader.sh 

./dropbox_uploader.sh

(follow instructions from script and for help https://github.com/andreafabrizi/Dropbox-Uploader)

curl "http://www.datsi.fi.upm.es/~frosal/sources/shc-3.8.9.tgz" -o shc-3.8.9.tgz

tar zxvf shc-3.8.9.tgz

rm shc-3.8.9.tgz

Edit script backup_wget.sh and add values for USERNAME, PASSWORD, VPS

cd shc-3.8.9

./shc -v -r -f ../backup_wget.sh 

cd ..

rm -rf shc-3.8.9

rm backup_wget.sh backup_wget.sh.c

(Put in a crontab the backup_wget.sh.x and Enjoy it :) )
