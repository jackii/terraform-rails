# Docker Usage Guide


## Inspect Docker

### See list of containers

```
docker ps
```

### See list of images

```
docker images
```

### See detailed docker usage, including containers, images and volumes

```
docker system df
```

Or

```
docker system df -v
```

## Clean Up

Dangling volumes are volumes that are not being used by a container. Dangling images are images that are not referenced
to by containers or other images.

### Delete orphaned and dangling volumes

```
docker volume rm $(docker volume ls -qf dangling=true)
```


### Delete dangling  and untagged images

```
docker rmi $(docker images -q -f dangling=true)
```

### Delete stopped containers, volumes and networks that are not used by containers
This also delete data containers you might have created
```
docker system prune -a
```

### !! Use the following commands with care !!

### Delete exited containers

This also delete data containers you might have created
```
docker rm $(docker ps -aqf status=exited)
```

### Delete all images

```
docker rmi $(docker images -q)
```

### Kill all running containers

```
docker kill $(docker ps -q)
```

### Delete all containers

```
docker rm $(docker ps -aq)
```

### Clean dangling images weekly

Create a script _~/docker-cleanup.sh_.
```
#!/bin/bash
docker rmi $(docker images -q -f dangling=true)
docker volume rm $(docker volume ls -qf dangling=true)
```
Put in your cronjob, `crontab -e`.

```
15 0 * * 1 ~/docker-cleanup.sh > /dev/null 2>&1
```

### Connect to the container via `docker-compose run`

```
docker-compose run app <command-to-run>
```

If you want to connect to the postgres, connect thru `app` and not directly to the `db` service

```
docker-compose run app psql -h db -U postgres
```

### Docker history
You can look at the history of the docker image, more importantly inspect the disk size

```
docker history <image_name>

# this is the example output of NGINX:alpine image

IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
3d40e5261d30        19 hours ago        /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B
cfbcbb6f514c        19 hours ago        /bin/sh -c #(nop)  EXPOSE 80                    0B
e8130c667e91        19 hours ago        /bin/sh -c envsubst '$RAILS_ROOT' < /tmp/doc…   1.27kB
498bd85d920e        19 hours ago        /bin/sh -c #(nop) COPY file:c1adec9506b4d1ac…   1.25kB
e23224a2b617        19 hours ago        /bin/sh -c #(nop) COPY dir:d1e7df5672a04bf33…   6.21GB   <--- LOOK AT THIS !!!
59901eec311d        19 hours ago        /bin/sh -c mkdir log                            0B
b2d8b4e5c41c        19 hours ago        /bin/sh -c #(nop) WORKDIR /var/www/app_name     0B
802ef97dbc7f        19 hours ago        /bin/sh -c #(nop)  ENV RAILS_ROOT=/var/www/a…   0B
5b45c384a9f1        19 hours ago        /bin/sh -c apt-get update -qq && apt-get -y …   22.5MB
dbfc48660aeb        6 days ago          /bin/sh -c #(nop)  CMD ["nginx" "-g" "daemon…   0B
<missing>           6 days ago          /bin/sh -c #(nop)  STOPSIGNAL [SIGTERM]         0B
<missing>           6 days ago          /bin/sh -c #(nop)  EXPOSE 80/tcp                0B
<missing>           6 days ago          /bin/sh -c ln -sf /dev/stdout /var/log/nginx…   22B
<missing>           6 days ago          /bin/sh -c set -x  && apt-get update  && apt…   53.8MB
<missing>           6 days ago          /bin/sh -c #(nop)  ENV NJS_VERSION=1.15.5.0.…   0B
<missing>           6 days ago          /bin/sh -c #(nop)  ENV NGINX_VERSION=1.15.5-…   0B
<missing>           6 days ago          /bin/sh -c #(nop)  LABEL maintainer=NGINX Do…   0B
<missing>           7 days ago          /bin/sh -c #(nop)  CMD ["bash"]                 0B
<missing>           7 days ago          /bin/sh -c #(nop) ADD file:f8f26d117bc4a9289…   55.3MB
```

### ssh into container

You can ssh into your running container

```
docker exec -it <image> sh
```

If you use `docker run -it` or `docker-compose run`, it will spin entire image up to run your command.
This is not necessary if your container is already running.


### Use AWS Container Regisry (ECR)

#### 1) Retrieve the login command to use to authenticate your Docker client to your registry.

```
$(aws ecr get-login --no-include-email --region ap-southeast-1)
```

#### 2) Package app for deployment

Package the app into a container image and then including the container image in a registry so that Amazon
ECS can access it for the production deployment.

```
docker build -t <DOCKER_HUB_USER>/app_name .
```

OR for Amazon ECR (Elastic Container Registry)

```
docker build -t app_name -f path/to/Dockerfile .
```

#### 3) Tag your image so you can push the image to this repository

```
docker tag app_name:latest your-aws-id-ecr.ecr.ap-southeast-1.amazonaws.com/app_name:latest
```

#### 4) Push this image to your newly created AWS repository

```
docker push your-aws-id-ecr.ecr.ap-southeast-1.amazonaws.com/app_name:latest
```
