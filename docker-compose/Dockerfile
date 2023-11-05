FROM ubuntu:latest

EXPOSE 80

RUN apt-get update && \
    apt-get install nginx -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY index.html /var/www/html

CMD ["nginx", "-g", "daemon off;"]