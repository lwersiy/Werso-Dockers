"docker container run hello-world"
"docker container run -dt -p 8080:80 nginx"
"docker container ls"
"docker container run --name nginx-container -dt -p 8081:80 nginx"   (Naming at runtime)
Recommended ports for publishing should be in between 1000 and 30000
"docker container stop container-ID"
"docker container start container-ID"
"docker container restart container-ID"
"docker container kill container-ID"
"docker container rm container-ID"
"docker pull imageNAME"

"docker images"
"docker rmi image-ID"
"docker rename imageID newimage-name"
"docker run --name newNAME -dt imageID"  (at download time)
"docker tag imageID imageNAME:TAG"  (naming existing image)


"docker container run -it --rm imageName" -it create an interactive session with the container's termina, --rm terminate container after exit 
-it  ==  -i -t
-i == interactive 
-t == pseudo-tty (teletype)
"docker exec -it containerID bash"
"docker exec -it containerID sh"
"docker run -dt -p 8082:80 nginx:latest sleep 10" ====> specific time for docker to be alive
"docker container run --rm --detach --name custom-nginx-packaged --publish 8080:80 myyoutube"
"docker container run --rm -it ubuntu"

=================

Building own docker file and image

<<<< create a Dockerfile>>>>

FROM ubuntu:latest

EXPOSE 80
RUN apt-get update && \
    apt-get install nginx && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["nginx", "-g", "daemon off;"]

===================================
Run the docker file to build an image

"docker image build ."
"docker container run --rm -dt --name mynewcontainer -p 8084:80 imageID"

"docker container prune" remove all containers


<<<<<<<<<<<< running an application from nginx image directly from docker hub >>>>>>>>>>>>

docker run -d -p 80:80 -v /home/ec2-user/docker/index.html:/usr/share/nginx/html/index.html nginx (USING CONTAINER VOLUME)




