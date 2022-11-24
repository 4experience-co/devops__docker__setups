FROM nginx:latest

RUN apt-get update

RUN apt-get install openssl -y
RUN apt-get install certbot -y

COPY setup.sh .

ENTRYPOINT ["sh", "setup.sh"]
