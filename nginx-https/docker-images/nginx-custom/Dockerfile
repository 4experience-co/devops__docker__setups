FROM nginx:latest

RUN apt-get update
RUN apt-get install openssl

COPY setup.sh .

ENTRYPOINT ["sh", "setup.sh"]
