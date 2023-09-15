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
