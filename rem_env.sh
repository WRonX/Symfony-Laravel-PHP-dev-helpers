#!/bin/bash
# New web environment creation script

echo "Removing web environment"

ENV_MAIN_FOLDER='/var/www/'
APACHE_CONFIG_FOLDER='/etc/apache2/sites-available/'

if [ "$EUID" -ne 0 ]
  then echo "Please run as root. Exiting."
  exit
fi

ENV_NAME=$1

if [ -z $ENV_NAME ]
    then
        echo "Specify environment name"
        exit
fi

echo "Confirm environment removal by retyping its name [$ENV_NAME]:"
read ENV_CONFIRM

if [ "$ENV_NAME" != "$ENV_CONFIRM" ]
	then
		echo "Confirmation failed, exiting..."
		exit
fi

# echo "Removing Apache config files..."
# rm $APACHE_CONFIG_FOLDER$ENV_NAME.conf
# rm $APACHE_CONFIG_FOLDER../sites-enabled/$ENV_NAME.conf
# echo "Removing environment folder..."
# rm -rf $ENV_MAIN_FOLDER$ENV_NAME
# echo "Removing environment host from /etc/hosts..."
# PATTERN="/127\.0\.0\.1\s$ENV_NAME/d"
# sed -i $PATTERN /etc/hosts
# echo "Restarting Apache service..."
# service apache2 restart

# echo "ALL DONE"
