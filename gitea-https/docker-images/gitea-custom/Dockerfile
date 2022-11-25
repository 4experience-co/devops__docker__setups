FROM gitea/gitea:1.17-dev

RUN apk update
RUN apk add openssl
RUN apk add certbot

COPY setup.sh .

ENTRYPOINT ["sh", "setup.sh"]
