###### Writing a Dockerfile

#########################################################################################

FROM ubuntu
RUN apt-get update -y
RUN apt-get install nginx -y
COPY index.html /var/www/html
CMD nginx -g 'daemon off;'

#########################################################################################

# after creating the file, safe and exit then run the following commands to build your image and the container
# docker build .
# docker run -dt -p 80:80 b99ce4845308 ===> because the image has no tags, use the image id instead

