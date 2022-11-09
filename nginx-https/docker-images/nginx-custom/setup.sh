#!/bin/bash

SSL_SELF_HOSTED=${SSL_SELF_HOSTED}

if ($SSL_SELF_HOSTED == true)
then
    echo "Using self-hosted SSL certifacte..."

    if  [ ! -f /ssl/.lock ]
    then
        echo "Generating self-hosted SSL certifacte..."

        if  [ ! -d /ssl ]
        then
            mkdir /ssl
        fi

        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /ssl/self-signed.key -out /ssl/self-signed.cert -subj "/C=PL"
        
        # Uncomment to use dhparam
        # openssl dhparam -out /ssl/dhparam.pem 4096
        
        chmod 755 /ssl/self-signed.cert /ssl/self-signed.key

        touch /ssl/.lock
    fi
fi

exec "$@"

nginx -g "daemon off;"
