#!/usr/bin/env bash
# Laravel directory permissions setup

echo "Laravel directory permissions setup"

if [ "$EUID" -ne 0 ]
  then echo "Please run as root. Exiting."
  exit
fi

PROJ_DIR=$1

if [ -z $PROJ_DIR ]; then 
    PROJ_DIR="."
fi

HTTP_GROUP=`ps axo group,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
ME=`logname`

# https://stackoverflow.com/a/37266353
echo "Changing directory owner . . ."
chown -R $ME:$HTTP_GROUP $PROJ_DIR
echo "Changing files' permissions . . ."
find $PROJ_DIR -type f -exec chmod 664 {} \;    
echo "Changing directories' permissions . . ."
find $PROJ_DIR -type d -exec chmod 775 {} \;    
echo "Changing storage/cache group . . ."
chgrp -R $HTTP_GROUP $PROJ_DIR/storage $PROJ_DIR/bootstrap/cache
echo "Changing storage/cache permissions . . ."
chmod -R ug+rwx $PROJ_DIR/storage $PROJ_DIR/bootstrap/cache
echo "ALL DONE"
