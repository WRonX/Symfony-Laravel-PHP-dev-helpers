#!/usr/bin/env bash
# Symfony directory permissions setup

echo "Symfony directory permissions setup"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root. Exiting."
  exit
fi

PROJ_DIR=$1

if [ -z $PROJ_DIR ]; then 
    PROJ_DIR="."
fi

HTTPDUSER=`ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
if [ -d "app/cache" ]; then
        setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX $PROJ_DIR/app/cache $PROJ_DIR/app/logs
        setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX $PROJ_DIR/app/cache $PROJ_DIR/app/logs
    elif [ -d "var/cache" ]; then
        setfacl -R -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX $PROJ_DIR/var/cache $PROJ_DIR/var/logs $PROJ_DIR/var/sessions
        setfacl -dR -m u:"$HTTPDUSER":rwX -m u:`whoami`:rwX $PROJ_DIR/var/cache $PROJ_DIR/var/logs $PROJ_DIR/var/sessions
    else    
        echo "Symfony 2.x/3.x directories not detected. Exiting."
        exit
fi  
echo "ALL DONE"

