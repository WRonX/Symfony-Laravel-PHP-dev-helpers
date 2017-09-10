#!/bin/bash
# New web environment creation script

echo "New web environment creation"

ENV_MAIN_FOLDER='/var/www/'
APACHE_CONFIG_FOLDER='/etc/apache2/sites-available/'
ADMIN_EMAIL='example@example.com'


ENV_NAME=$1
WEB_FOLDER=$2

if [ "$EUID" -ne 0 ]
  then echo "Please run as root. Exiting."
  exit
fi

printf "New environment name: "

if [ -z $ENV_NAME ]
    then 
        read ENV_NAME
    else
        echo $ENV_NAME
fi

if [ -z $WEB_FOLDER ]
    then 
        WEB_FOLDER="web"
fi


APACHE_CONFIG="$APACHE_CONFIG_FOLDER$ENV_NAME.conf"
ENV_FOLDER=$ENV_MAIN_FOLDER$ENV_NAME

echo "Creating folder for files..."
echo "    $ENV_FOLDER"
mkdir $ENV_FOLDER

echo "Creating configuration file for Apache..."
echo "    $APACHE_CONFIG"

echo "<VirtualHost *:80>" > $APACHE_CONFIG
echo "    ServerName $ENV_NAME" >> $APACHE_CONFIG
echo "    ServerAlias www.$ENV_NAME" >> $APACHE_CONFIG
echo "    ServerAdmin $ADMIN_EMAIL" >> $APACHE_CONFIG
echo "    DocumentRoot \"/var/www/$ENV_NAME/$WEB_FOLDER\"" >> $APACHE_CONFIG
echo "    <Directory \"/var/www/$ENV_NAME/$WEB_FOLDER\">" >> $APACHE_CONFIG
echo "        Options Indexes Includes ExecCGI FollowSymLinks SymLinksifOwnerMatch" >> $APACHE_CONFIG
echo "        AllowOverride All" >> $APACHE_CONFIG
echo "        Order allow,deny" >> $APACHE_CONFIG
echo "        Allow from all" >> $APACHE_CONFIG
echo "        Require all granted" >> $APACHE_CONFIG
echo "    </Directory>" >> $APACHE_CONFIG
echo "    ErrorLog \${APACHE_LOG_DIR}/$ENV_NAME.error.log" >> $APACHE_CONFIG
echo "    CustomLog \${APACHE_LOG_DIR}/$ENV_NAME.access.log combined" >> $APACHE_CONFIG
echo "</VirtualHost>" >> $APACHE_CONFIG

echo "Creating symlink for configuration file..."
ln -t $APACHE_CONFIG_FOLDER../sites-enabled/ -s $APACHE_CONFIG

echo "Adding environment to hosts..."
echo "127.0.0.1        $ENV_NAME" >> /etc/hosts
echo "Restarting Apache service..."
service apache2 restart

echo "ALL DONE"
