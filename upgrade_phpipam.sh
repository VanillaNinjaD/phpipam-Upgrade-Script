!/bin/bash

#-----------------------
# DEFINE VARIABLES HERE
#-----------------------
WEBSERVICENAME="apache2"
WEBSERVERUSER="www-data"
WEBSERVERDIRECTORY="/var/www/"
PHPIPAMDIRECTORY="phpipam"
MYSQLDUMPPATH="/usr/bin/mysqldump"
DBNAME="phpipam"
DBUSER="phpipam"
DBPASS="phpipam"

#----------------
# PERFORM CHECKS
#----------------
if [[ $EUID -ne 0 ]]; then
   echo "THIS SCRIPT MUST BE RUN AS ROOT!!!" 1>&2
   exit 1
fi
if [ -a master.zip ]
  then
    rm master.zip
fi

#--------------
# START SCRIPT
#--------------
wget -c https://github.com/phpipam/phpipam/archive/master.zip
unzip master.zip
service $WEBSERVICENAME stop
$MYSQLDUMPPATH -u $DBUSER -p$DBPASS $DBNAME > $WEBSERVERDIRECTORY/$PHPIPAMDIRECTORY/db/bkp/phpipam__migration_backup.bak
mv $WEBSERVERDIRECTORY/$PHPIPAMDIRECTORY/ "$WEBSERVERDIRECTORY/$PHPIPAMDIRECTORY.$(date +%F_%R)/"
BACKUPDIR=$(ls -td $WEBSERVERDIRECTORY/$PHPIPAMDIRECTORY_old*/ | head -1)
mv phpipam-master/ $WEBSERVERDIRECTORY/$PHPIPAMDIRECTORY
cp $BACKUPDIR/config.php $WEBSERVERDIRECTORY/$PHPIPAMDIRECTORY/
chown -R $WEBSERVERUSER:$WEBSERVERUSER $WEBSERVERDIRECTORY/$PHPIPAMDIRECTORY
service $WEBSERVICENAME start
