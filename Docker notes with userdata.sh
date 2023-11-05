## spin up an AmzLinux2 instance
#!/bin/bash
sudo su
sudo yum update -y
sudo yum install docker -y
systemctl start docker
systemctl enable docker
docker run -dt -p 80:80 nginx  ##-dt means detached mode. this is because it pulls a new image from the library. 
##==> -p is called port binding. this mechanizm is called mapping
##==> 80:80 means one port is the container port, and the other port is ec2 instance port
##===> The port on the left hand side is the access port on the ec2 instance
##====> Any other application would have to be installed on a different port


Docker ps  ===> shows running container
Docker ps -a  ===> List all containers, current and existed
Docker images ====> shows images
Docker --version #: shows currently installed version
docker run -dt -p 80:80 nginx
docker run -dt nginx =====> this will create an nginx container in a detached mode
docker run nginx  ========> this will not create any more containers once an nginx containter is alrea running
docker rm "container_id" ====> remove containers
docker rmi "image_name" ======> remove image
docker run ======> pull images from docker hub and creates containers
docker pull ======> only pulls containers
docker kill ======> stop container

FROM.==========>
LABEL.=========>
ENV.===========>
RUN.===========>
COPY.==========>
ADD.===========>
ENTRYPOINT.====>
EXPOSE.========>
CMD. ==========>

dockerfile
     (build)
dockerimage ----> Dockerhub/AWS ECR
     (create)
dockercontainers

# Dockerfile
##### Writing a Dockerfile

########################################################################################

  <<<<<<<<<<<< running an application from nginx image directly from docker hub >>>>>>>>>>>>

docker run -d -p 80:80 -v /home/ec2-user/docker/index.html:/usr/share/nginx/html/index.html nginx


########################################################################################

FROM ubuntu
RUN apt-get update -y
RUN apt-get install nginx -y
COPY index.html /var/www/html
CMD nginx -g 'daemon off;'

########################################################################################

after creating the file, safe and exit then run the following commands to build your image and the container
docker build .
docker run -dt -p 80:80 b99ce4845308 ===> because the image has no tags, use the image id instead

########################################################################################
docker container kill $(docker container ls -aq) ====> kill all containers
docker container rm $(docker container ls -aq)   ====> removes all killed containers

docker image pull nginx =========> pulls nginx image from docker hub

########################################################################################

# ****GETTING INSIDE A CONTAINER****
docker exec -it containerID bash  ===> to bash into a container
docker exec -it containerID sh ===> to sh into a container

##############################################################

docker run -d ngix:latest sleep 60 ====> specific time for docker to be alive
docker run -dt -p 8082:80 nginx:latest sleep 10 ====> specific time for docker to be alive
##################################################################
#Docker Restart Policies
#docker restart command =====> 
docker run -dt --restart always nginx
no ---> container dies once we restart docker/stop container/kil container 
always ----> container alsways comes up even if you restart docker/stop container/kil container
docker run -d my-image
docker run -d --restart=no my-image ===> Don ot automatically restart image
docker run -d --restart=always my-image ===> always restart the containter if it stops
docker run -d --restart=on-failure:5 --restart-interval=10s my-image ===> restart container if it exits due to an error, which manifests as a non-zero exit code.
docker run -d --restart=unless-stopped my-image ===> restart the container unless it is explicitly stopped or Docker itself is stopped or restarted.
docker run -d --restart=on-failure:3 --restart-interval=5s my-image ===> 

#############################################################
####### Docker Commands ###########
docker system df ===>shows you details about docker
docker info ===> shows details about docker
docker inspect containerID ====> shows all details of a container
docker rm $(docker container ls -aq) ===> remove docker containters
docker stop $(docker container ls -aq) ===> stops all running containers
docker run -dt --rm nginx ===> this --rm flag means when every the container is stopped, it will be automaticall be removed
#####################################################################################
This command will run a container with jenkins image
docker run -d --name=Jenkins-Master -p 8080:8080 -p 50000:50000 -v jenkins-data:/var jenkins/jenkins
Then docker exec -it ContainerID sh ==> to ssh in to the container
Then cat /var/jenkins_home/secrets/initialAdminPassword
#####################################################################################
compress or zip command
tar -czvf file1.tar.gz file1.txt
tar -czvf ==> command
file1.tar.gz ==> outcome of the command
file1.txt ==> input of the command
######################################################################################
ADD and COPY command does similar job by moving file from local to docker. however ADD command can unzip and move the file from local to docker
######################################################################################

FROM busybox
RUN mkdir /root/demo
WORKDIR /root/demo ===> In order to prevent repeatative lines of commands, the work directory can be used to indicate every subsequent commands be directed into that specific directory. for example, file.txt will be created in the specified work directory.
RUN touch file.txt
WORKDIR /  ===> work directory now root
CMD ["/bin/sh"]

######################################################################################
Using Environment Variables
ENV VERSION 1.8 ===> When this environment variable is set up, everywhere VERSION is found, it will be replaced by 1.8.
****************Sample Dockerfile*****************
FROM busybox
ENV VERSION 1.8
RUN touch test-$VERSION.txt #### $ must be present for the conversion to occur.
CMD ["bin/sh"]
################################################################################
Naming Docker Images during creation
docker build . -t imageNAME:TAG
docker build . -t firstimage:v1

Naming Existing images
docker tag imageID imageNAME:TAG
docker tag 8912f4be8bd3 firstimage:v2

#################################################################################
Naming Docker Container during creation

docker run --name newNAME -dt imageID
docker run --name werso -dt 8912f4be8bd3

Naming existing container
docker rename imageID newNAME
docker rename 435148723c6a werso
#################################################################################   
Some commands
docker history nginx
docker inspect firstimage --format='{{.Os}}'

#################################################################################
Exporting and importing Docker containers to and from s3 bucket

docker export c99306fd49f9 > myfirstcontainerzip.tar ===> zip container
aws s3 cp myfirstcontainerzip.tar s3://wersobucket111 --region us-east-1 ===> Export container to s3
aws s3 cp s3://wersobucket111/myfirstcontainerzip.tar /home/ec2-user/demo3 ===> Import container from s3 bucket

cat myfirstcontainerzip.tar | docker import - brandnew:latest ===> creating images from imported container

docker run -dt ca76f68c13e3 /bin/bash ===> use image to run container


aws s3 cp s3://your-s3-bucket/path/to/docker-image.tar /path/on/ec2/

##################################################################################

PUSHING AND PULLING DOCKER CONTAINER IMAGES TO AND FROM PUBLIC AND PRIVATE REPOSITORIES

<<<REPOS>>>
Github
Gitlab
Nexus
ECS
ECR
Dockerhub

<<<<Two types of repos are PRIVATE and PUBLIC Repository>>>>

Private Repos: Only you have access to this repor. You have access to both PULL $ PUSH
Public Repos: Everyone can pull images, however pushing is not allowed.


<<<<<<<<<<<<< Pushing to Dockerhub >>>>>>>>>>>>>>>>>>>>

Tag Your Image:

Before you can push an image to a remote repository, you need to tag it with the repository's URL. Use the following command to tag your image:

1) list images to identify the image you want to push

[root@ip-10-0-3-135 docker]# docker images
REPOSITORY           TAG       IMAGE ID       CREATED       SIZE
nginx                latest    bc649bab30d1   12 days ago   187MB


2) Tag the local image with the remote repository

docker tag <image-id> <repo-name>:tag-name

docker tag bc649bab30d1 wersiygb/wersorepo:v1

3: Push to Docker up repo

docker push wersiygb/wersorepo:v1

##################################################################################################

<<<<<<<<<<<< Pushing Docker Images to AWS ECR >>>>>>>>>>>>>>

--- create an AWS ECR repo
--- Attache a role to the host instance, or run aws configure
--- select the repo and click on PUSH COMMAND FOR <repo-name>
--- run the command "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 989589514705.dkr.ecr.us-east-1.amazonaws.com"
--- build your image using ECR Repo name "docker build -t wersoecr" or simply rename your image with repo name
--- tag your image using command "docker tag wersoecr:latest 989589514705.dkr.ecr.us-east-1.amazonaws.com/wersoecr:latest"
--- Push to ECR using command "docker push 989589514705.dkr.ecr.us-east-1.amazonaws.com/wersoecr:latest"

#######################################################################################################

<<<<<<<<<< Updating and Commiting Docker containers >>>>>>>>>>

=== In a case of emergency, log in to the container using command "docker exec -it <container-ID> bash"
=== Install the new application in the docker container using commands such as yum, apt-get etc.
=== after installing application, commit the container in order to update the image using the below command
"docker container commit my-container my-custom-image:latest"
=== Now your new image has 2 applications running.

#########################################################################################################

The difference between docker container and docker image is the top writable layer.
All writes to the container that adds or modifies existing data are stored in the writable layer.

#########################################################################################################

<<<<<<<<<<<<< Docker Network >>>>>>>>>>>>

Network Drivers: bridge, host, none, overlay, macvlan

- "ifconfig" lists network properties
- "docker network ls" this will list the different network ID and drivers
- "docker network inspect bridge" This will give you details on the bridge driver
- docker0 is the gateway for any traffic entering the docker network.
- "apt-get update -y && apt-get install net-tools" This command install network tools in an ubuntu server.
- "apt-get install iputils-ping" this command install the ping tool
- By default all docker container utilizes the bridge network. This meanse containers in the same network can easily communicate with each other.

<<<<<<<<<<<<<< Creating a costum bridge Network>>>>>>>>>>>>>

- "brctl show"
- "yum install bridge-utils"
- "docker network create --driver bridge myfirstbridge"
- "docker network ls"
- to run a container into a specific network, just pass the flag as below
- "docker run -dt -p 8081:80 --network myfirstbridge nginx"

###############################################################################################################

<<<<<<<<<<<< Docker Storage >>>>>>>>>>>>>>
<<<<<<<<< PERSISTENT VOLUME >>>>>>>>>>>>>>
- "docker volume ls"
- "docker volume create myvolume1"
- path to volume on local instance "/var/lib/docker/volumes/myvolume1/_data"
- "docker volume inspect myvolume1"
- "docker run -dt -p 8082:80 --volume myvolume1 nginx"
- "docker run -dt -v myvolume1:/etc busybox sh" 
in the above command, myvolume1 is present in ec2 path above
busybox container is created and the data is stored in container etc folder
container etc is connected to myvolume1 of ec2 instance. this operates as file share. 
whenever data is added in etc, it automatically update in myvolume1 in ec2.
if the container dies, the myvolume1 can be attached to a new container.


<<<<<<< Mount Types >>>>>>>>>

1) Bind Mounts: This links a directory or file on the host system to a directory inside the container.
     Useful for sharing config files, source code, and othe data.
     "docker run -v /path/to/host:/path/in/container my-image"

2) Volume Mounts: Here we create a named volume managed by docker and provide a way to store and manage dater separete from container's lifecycle.
     Use best for persist volume beyond container lifestyle 
     "docker volume create my-volume"
     "docker run -v my-volume:/path/in/container my-image"

3) tmpfs Mount: This allow you to store data temporaly in the RAM of the host system.
     Data in this system are not persisted on the host.
     Best use for temporary storage or for cases where you want to minimize diks I/O.
     "docker run --tmpfs /path/in/container my-image"

NOTE: it is important to note that the best way to store data is in S3 or Database.


####################################################################################################

=========== DOCKER COMPOSE =============

This allows you to utilize 1 command to create and start all services by using a single yaml file


====================================================================

# create python file app.py


from flask import Flask

app = Flask(__name__)


@app.route('/')
def hello_docker():
    return "<h1>Hello, Docker!</h1>"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)



=================================================================

# Now create a file app.Dockerfile for this python file

FROM python:3.8-slim

WORKDIR /app

COPY app.py .

RUN pip install flask

EXPOSE 5000

CMD ["python", "app.py"]

==================================================================

# Great, lets work with the docker-compose file now.

# Create a file docker-compose.yaml


version: '3'
services:
  myyoutube:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:80"

  app:
    build:
      context: .
      dockerfile: app.Dockerfile
    ports:
      - "8082:5000"



To execute this docker compose, run

"docker-compose up -d"
To bring it down

"docker-compose down"


============== INSTALL DOCKER COMOSE ON ec2 ================