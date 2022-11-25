#!/bin/bash

echo "Running: setup.sh"
echo "Current directory:" $(pwd)

DOMAINS=${DOMAINS:=""}

if [ ! -d /data/gitea ]
then
    mkdir /data/gitea
fi

if [ ! -d /data/gitea/conf ]
then
    mkdir /data/gitea/conf
fi

if [ "$DOMAINS" = "" ]
then
    echo "No DOMAINS environment variable value."
    echo "Using self-hosted SSL certifacte..."

    if  [ ! -f /etc/self-signed/.lock ]
    then
        echo "Generating self-hosted SSL certifacte..."

        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/self-signed/privkey.pem -out /etc/self-signed/fullchain.pem -subj "/C=PL"
        
        # Uncomment to use dhparam
        # openssl dhparam -out /ssl/dhparam.pem 4096
        
        chmod 755 /etc/self-signed/fullchain.pem /etc/self-signed/privkey.pem

        touch /etc/self-signed/.lock
    fi

    if [ ! -f /data/gitea/conf/app.ini ]
    then
        cp /conf/app-self-signed.ini /data/gitea/conf/app.ini
    fi
else
    echo "DOMAINS: $DOMAINS"
    
    if  [ ! -f /etc/letsencrypt/.lock ]
    then
        certbot certonly --standalone --cert-name domains --domains $DOMAINS --non-interactive --email 'sebastian.stryczek@4experience.co' --agree-tos

        chmod -R 755 /etc/letsencrypt
        
        touch /etc/letsencrypt/.lock
    fi

    if [ ! -f /data/gitea/conf/app.ini ]
    then
        cp /conf/app-letsencrypt.ini /data/gitea/conf/app.ini
    fi
fi

chown -R 1000:1000 /data
chmod -R 755 /data

exec /usr/bin/entrypoint "$@"
