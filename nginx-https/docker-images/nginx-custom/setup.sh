#!/bin/bash

DOMAIN=${DOMAIN:=""}

if [ "$DOMAIN" = "" ]
then
    echo "No DOMAIN environment variable value."
    echo "Using self-hosted SSL certifacte..."

    if  [ ! -f /ssl/.lock ]
    then
        echo "Generating self-hosted SSL certifacte..."

        if  [ ! -d /ssl ]
        then
            mkdir /ssl
        fi

        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/self-signed/privkey.pem -out /etc/self-signed/fullchain.pem -subj "/C=PL"
        
        # Uncomment to use dhparam
        # openssl dhparam -out /ssl/dhparam.pem 4096
        
        chmod 755 /etc/self-signed/fullchain.pem /etc/self-signed/privkey.pem

        touch /etc/self-signed/.lock
    fi

    cp /etc/nginx/available-confs/nginx-self-signed.conf /etc/nginx/conf.d/nginx.conf
else
    echo "DOMAIN: $DOMAIN"
    
    certbot certonly --standalone --domains $DOMAIN --non-interactive --email 'sebastian.stryczek@4experience.co' --agree-tos

    cp /etc/nginx/available-confs/nginx-letsencrypt.conf /etc/nginx/conf.d/nginx.conf
fi

exec "$@"

nginx -g "daemon off;"
