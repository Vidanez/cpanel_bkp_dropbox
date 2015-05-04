# CPANEL BACKUP TO DROPBOX USING WGET
Cpanel Backup using wget to pull it and dropbox as destination using dropbox uploader. Also ofuscation with SHC
Requirements:
https://github.com/andreafabrizi/Dropbox-Uploader
Installed and configured to use API

In order to avoid to have the password and username in plain text the recommendation is to use the following to ofuscate the code
http://www.datsi.fi.upm.es/~frosal/sources/shc-3.8.9.tgz 
http://www.thegeekstuff.com/2012/05/encrypt-bash-shell-script/ 



STEPS
mkdir /home/<username>/scripts
cd /home/<username>/scripts
curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o dropbox_uploader.sh
curl “http://www.datsi.fi.upm.es/~frosal/sources/shc-3.8.9.tgz” -o shc-3.8.9.tgz
tar zxvf shc-3.8.9.tgz
rm shc-3.8.9.tgz
cd shc-3.8.9.tgz
make
vi backup_wget
USERNAME=
PASSWORD=
VPS=
