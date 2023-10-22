# Docker

## Introduction

##### As per IBM

```Containerization involves encapsulating or packaging up software code and all its dependencies so that it can run uniformly and consistently on any infrastructure.```

##### In human words -

Consider a real life scenario here. Assume you have developed an awesome book management application that can store information regarding all the books you own, and can also serve the purpose of a book lending system for your friends.

‌If you make a list of the dependencies, that list may look as follows:

- Node.js
- Express.js
- SQLite3

Theoretically this should be it. But practically there are some other things as well. Turns out [Node.js](https://nodejs.org/) uses a build tool known as `node-gyp` for building native add-ons. And according to the [installation instruction](https://github.com/nodejs/node-gyp#installation) in the [official repository](https://github.com/nodejs/node-gyp), this build tool requires Python 2 or 3 and a proper C/C++ compiler tool-chain.

Taking all these into account, the final list of dependencies is as follows:

- Node.js
- Express.js
- SQLite3
- Python 2 or 3
- C/C++ tool-chain

Now depending upon the operating system, the installation procedure would vary. Your installation might break due to OS upgrades. Let's say you're doing your installation on a CentOs Linux machine and let's assume that you've gone through all the hassle of setting up the dependencies and have started working on the project. Does that mean you're out of danger now? Of course not.

Your manager uses Windows and to demo the application on his machine you've to go through the hassle of setting up the whole thing in Windows now. You have to consider the inconsistencies of how these two different operating systems handle paths.

Again when you plan to deploy on production, the os is different. It is an ubuntu server. Now you're in trouble again, you've to handle the same inscosistancies again. The installations are different the packages are different. 

AAaaaagghhhh Its such a pain!

All these issues can be solved if only you could somehow:

- Develop and run the application inside an isolated environment (known as a container) that matches your final deployment environment.
- Put your application inside a single file (known as an image) along with all its dependencies and necessary deployment configurations.
- And share that image through a central server (known as a registry) that is accessible by anyone with proper authorization.

Well then everyone would be able to download the image from the registry, run the application as it is within an isolated environment free from the platform specific inconsistencies, or even deploy directly on a server, since the image comes with all the proper production configurations.

Thus the Docker Platform as per Docker Docs - 

##### Docker Platform

Docker provides the ability to package and run an application in a loosely isolated environment called a container. The isolation and security lets you to run many containers simultaneously on a given host. Containers are lightweight and contain everything needed to run the application, so you don't need to rely on what's installed on the host. You can share containers while you work, and be sure that everyone you share with gets the same container that works in the same way.

## Installation

Install Docker Desktop Here : 

[Docker Desktop: The #1 Containerization Tool for Developers | Docker](https://www.docker.com/products/docker-desktop/) 

The Docker Desktop package on Windows or Mac is a collection of tools like `Docker Engine`, `Docker Compose`, `Docker Dashboard`, `Kubernetes` and a few other goodies.

### Running your First Container

Open up the terminal and run the following command:

```docker
docker run hello-world
```

The [hello-world](https://hub.docker.com/_/hello-world) image is an example of minimal containerization with Docker. It has a single program compiled from a [hello.c](https://github.com/docker-library/hello-world/blob/master/hello.c) file responsible for printing out the message you're seeing on your terminal.

Now in your terminal, you can use the `docker ps -a` command to have a look at all the containers that are currently running or have run in the past:

```docker
docker ps -a

# CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
# 128ec8ceab71        hello-world         "/hello"            14 seconds ago      Exited (0) 13 seconds ago                      exciting_chebv
```

Now in order to understand what just happened behind the scenes, you'll have to get familiar with the Docker Architecture and three very fundamental concepts of containerization in general, which are as follows:

- Container
- Image
- Registry

### What is a Container?

In the world of containerization, there can not be anything more fundamental than the concept of a container.

```A container is an abstraction at the application layer that packages code and dependencies together. Instead of virtualizing the entire physical machine, containers virtualize the host operating system only.```

Just like virtual machines, containers are completely isolated environments from the host system as well as from each other. They are also a lot lighter than the traditional virtual machine, so a large number of containers can be run simultaneously without affecting the performance of the host system.‌

Containers and virtual machines are actually different ways of virtualizing your physical hardware. The main difference between these two is the method of virtualization.

Virtual machines are usually created and managed by a program known as a hypervisor, like [Oracle VM VirtualBox](https://www.virtualbox.org/), [VMware Workstation](https://www.vmware.com/), [KVM](https://www.linux-kvm.org/), [Microsoft Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/about/) and so on. This hypervisor program usually sits between the host operating system and the virtual machines to act as a medium of communication.



<img src="file:///Users/showmikbose/Library/Application%20Support/marktext/images/2023-10-22-14-55-42-image.png" title="" alt="" width="460">



Each virtual machine comes with its own guest operating system which is just as heavy as the host operating system. The application running inside a virtual machine communicates with the guest operating system, which talks to the hypervisor, which then in turn talks to the host operating system to allocate necessary resources from the physical infrastructure to the running application.

As you can see, there is a long chain of communication between applications running inside virtual machines and the physical infrastructure. The application running inside the virtual machine may take only a small amount of resources, but the guest operating system adds a noticeable overhead.

Unlike a virtual machine, a container does the job of virtualization in a smarter way. Instead of having a complete guest operating system inside a container, it just utilizes the host operating system via the **container runtime** while maintaining isolation.



<img src="file:///Users/showmikbose/Library/Application%20Support/marktext/images/2023-10-22-14-59-57-image.png" title="" alt="" width="467">

So what the heck is **container runtime** ?

The container runtime, that is **Docker**, sits between the containers and the host operating system instead of a hypervisor. The containers then communicate with the container runtime which then communicates with the host operating system to get necessary resources from the physical infrastructure. As a result of eliminating the entire guest operating system layer, containers are much lighter and less resource-hogging than traditional virtual machines.

Also, does that mean docker isn't the only container runtime? Well exactly. There are tools like Podman, CRI-O etc.

```
uname -a
# Linux alpha-centauri 5.8.0-22-generic #23-Ubuntu SMP Fri Oct 9 00:34:40 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

docker run alpine uname -a
# Linux f08dbbe9199b 5.8.0-22-generic #23-Ubuntu SMP Fri Oct 9 00:34:40 UTC 2020 x86_64 Linux
```

In the code block above, I have executed the `uname -a` command on my host operating system to print out the kernel details. Then on the next line I've executed the same command inside a container running [Alpine Linux](https://alpinelinux.org/).

As you can see in the output, the container is indeed using the kernel from my host operating system. This goes to prove the point that containers virtualize the host operating system instead of having an operating system of their own.

### What is a Docker Image?

Images are multi-layered self-contained files that act as the template for creating containers. They are like a frozen, read-only copy of a container. Images can be exchanged through registries.

The [Open Container Initiative (OCI)](https://opencontainers.org/) defined a standard specification for container images which is complied by the major containerization engines out there. This means that an image built with Docker can be used with another runtime like Podman without any additional hassle.

Containers are just images in running state. When you obtain an image from the internet and run a container using that image, you essentially create another temporary writable layer on top of the previous read-only ones.

### What is a Docker Registry?

An image registry is a centralized place where you can upload your images and can also download images created by others. [Docker Hub](https://hub.docker.com/) is the default public registry for Docker.



## Docker Architecture Overview

The engine consists of three major components:

1. **Docker Daemon:** The daemon (`dockerd`) is a process that keeps running in the background and waits for commands from the client. The daemon is capable of managing various Docker objects.
2. **Docker Client:** The client  (`docker`) is a command-line interface program mostly responsible for transporting commands issued by users.
3. **REST API:** The REST API acts as a bridge between the daemon and the client. Any command issued using the client passes through the API to finally reach the daemon.

As per docs: 

```
Docker uses a client-server architecture. The Docker client talks to the Docker daemon, which does the heavy lifting of building, running, and distributing your Docker containers
```

You as a user will usually execute commands using the client component. The client then use the REST API to reach out to the long running daemon and get your work done.

![](/Users/showmikbose/Library/Application%20Support/marktext/images/2023-10-22-15-13-07-image.png)

To simplify it further, let's look at what exactly happens when you issue the docker run command : 

![](/Users/showmikbose/Library/Application%20Support/marktext/images/2023-10-22-15-14-24-image.png)

1. You execute `docker run hello-world` command where `hello-world` is the name of an image.
2. Docker client reaches out to the daemon, tells it to get the `hello-world` image and run a container from that.
3. Docker daemon looks for the image within your local repository and realizes that it's not there, resulting in the `Unable to find image 'hello-world:latest' locally` that's printed on your terminal.
4. The daemon then reaches out to the default public registry which is Docker Hub and pulls in the latest copy of the `hello-world` image, indicated by the `latest: Pulling from library/hello-world` line in your terminal.
5. Docker daemon then creates a new container from the freshly pulled image.
6. Finally Docker daemon runs the container created using the `hello-world` image outputting the wall of text on your terminal.



### How to Run a Container

Previously you've used `docker run` to create and start a container using the `hello-world` image. The generic syntax for this command is as follows:

```
docker run <image name>
```

Although this is a perfectly valid command, there is a better way of dispatching commands to the `docker` daemon.

Prior to version `1.13`, Docker had only the previously mentioned command syntax. Later on, the command-line was [restructured](https://www.docker.com/blog/whats-new-in-docker-1-13/) to have the following syntax:

```
docker <object> <command> <options>
```

In this syntax:

- `object` indicates the type of Docker object you'll be manipulating. This can be a `container`, `image`, `network` or `volume` object.
- `command` indicates the task to be carried out by the daemon, that is the `run` command.
- `options` can be any valid parameter that can override the default behavior of the command, like the `--publish` option for port mapping.

Now, following this syntax, the `run` command can be written as follows:

```
docker container run <image name>
```

The `image name` can be of any image from an online registry or your local system. As an example, you can try to run a container using the [fhsinchy/hello-dock](https://hub.docker.com/r/fhsinchy/hello-dock) image. This image contains a simple [Vue.js](https://vuejs.org/) application that runs on port 80 inside the container.



To run a container using this image, execute following command on your terminal:

```
docker container run --publish 8080:80 fhsinchy/hello-dock
```

To allow access from outside of a container, you must publish the appropriate port inside the container to a port on your local network. The common syntax for the `--publish` or `-p` option is as follows:

```
--publish <host port>:<container port>
```

Another very popular option of the `run` command is the `--detach` or `-d` option. In the example above, in order for the container to keep running, you had to keep the terminal window open.

```
docker container run --detach --publish 8080:80 fhsinchy/hello-dock
```

### How to List Containers

The `container ls` command can be used to list out containers that are currently running. To do so execute following command:

```
docker container ls
```

The `container ls` command only lists the containers that are currently running on your system. In order to list out the containers that have run in the past you can use the `--all` or `-a` option.

```
docker container ls --all
```

### How to Name or Rename a Container

Naming a container can be achieved using the `--name` option. To run another container using the `fhsinchy/hello-dock` image with the name `hello-dock-container` you can execute the following command:

```
docker container run --detach --publish 8888:80 --name hello-dock-container fhsinchy/hello-dock
```

You can even rename old containers using the `container rename` command. Syntax for the command is as follows:

```
docker container rename <container identifier> <new name> 
```

### How to Stop a container

 Generic syntax for the command is as follows:

```
docker container stop <container identifier> 
```

### Start & Restart a container

The `container start` command can be used to start any stopped or killed container. The syntax of the command is as follows:

```
docker container start <container identifier>
```

The `container restart` command follows the exact syntax as the `container start` command.

```
docker container restart <container identifier>
```

### How to Create a Container Without Running

So far in this section, you've started containers using the `container run` command which is in reality a combination of two separate commands. These commands are as follows:

- `container create` command creates a container from a given image.
- `container start` command starts a container that has been already created.

### How to remove dangling images

Containers that have been stopped or killed remain in the system. These dangling containers can take up space or can conflict with newer containers.

In order to remove a stopped container you can use the `container rm` command. The generic syntax is as follows:

```
docker container rm <container identifier>
```

```
docker container ls --all

# CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS                      PORTS                  NAMES
# b1db06e400c4        fhsinchy/hello-dock   "/docker-entrypoint.…"   6 minutes ago       Up About a minute           0.0.0.0:8888->80/tcp   hello-dock-container
# 9f21cb777058        fhsinchy/hello-dock   "/docker-entrypoint.…"   10 minutes ago      Up About a minute           0.0.0.0:8080->80/tcp   hello-dock-container-2
# 6cf52771dde1        fhsinchy/hello-dock   "/docker-entrypoint.…"   10 minutes ago      Exited (0) 10 minutes ago                          reverent_torvalds
# 128ec8ceab71        hello-world           "/hello"                 12 minutes ago      Exited (0) 12 minutes ago                          exciting_chebyshev
```

As can be seen in the output, the containers with ID `6cf52771dde1` and `128ec8ceab71` are not running. To remove the `6cf52771dde1` you can execute the following command:

```
docker container rm 6cf52771dde1

# 6cf52771dde1
```

Instead of removing individual containers, if you want to remove all dangling containers at one go, you can use the `container prune` command.



### How to Run a Container in Interactive Mode

So far you've only run containers created from either the [hello-world](https://hub.docker.com/_/hello-world) image or the [fhsinchy/hello-dock](https://hub.docker.com/r/fhsinchy/hello-dock) image. These images are made for executing simple programs that are not interactive.

Well, all images are not that simple. Images can encapsulate an entire Linux distribution inside them. These images do not just run some pre-configured program. These are instead configured to run a shell by default. In case of the operating system images it can be something like `sh` or `bash` and in case of the programming languages or run-times, it is usually their default language shell. These images require a special `-it` option to be passed in the `container run` command.

```
docker container run --rm -it ubuntu
```

The `-it` option sets the stage for you to interact with any interactive program inside a container. This option is actually two separate options mashed together. 

```i``` stands for interactive and ```t``` stands for tty.



### How to Execute Commands Inside a Container

And the generic syntax for passing a command to a container that is not running is as follows:

```
docker container run <image name> <command>
```

What happens here is that, in a `container run` command, whatever you pass after the image name gets passed to the default entry point of the image.

An entry point is like a gateway to the image. Most of the images except the executable images use shell or `sh` as the default entry-point. So any valid shell command can be passed to them as arguments.





# How to Create a Docker Image

--- Coming Soon ---

# Index

- Installation Guide : [Docker Desktop: The #1 Containerization Tool for Developers | Docker](https://www.docker.com/products/docker-desktop/) 

- Official [reference](https://docs.docker.com/engine/reference/commandline/container/) for the Docker command-line. 

- Official Docs : [Docker overview | Docker Docs](https://docs.docker.com/get-started/overview/) 
