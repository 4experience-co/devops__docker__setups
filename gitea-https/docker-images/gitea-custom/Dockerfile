FROM gitea/gitea:1.17.3

RUN apk update
RUN apk add openssl

COPY setup.sh .

ENTRYPOINT ["sh", "setup.sh"]
