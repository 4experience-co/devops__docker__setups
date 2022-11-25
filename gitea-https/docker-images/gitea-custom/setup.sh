#!/bin/bash

echo "Running: setup.sh"
echo "Current directory:" $(pwd)

DOMAINS=${DOMAINS:=""}

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

    cp /data/conf/app-self-signed.ini /data/gitea/conf/app.ini
else
    echo "DOMAINS: $DOMAINS"
    
    if  [ ! -f /etc/letsencrypt/.lock ]
    then
        certbot certonly --standalone --cert-name domains --domains $DOMAINS --non-interactive --email 'sebastian.stryczek@4experience.co' --agree-tos

        touch /etc/letsencrypt/.lock
    fi

    cp /data/conf/app-letsencrypt.ini /data/gitea/conf/app.ini
fi

exec /usr/bin/entrypoint "$@"
