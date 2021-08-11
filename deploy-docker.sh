#!/bin/bash

source ./deploy-variables

if [ -z "$DOCKER_AUTH" ]
then
    echo "Docker auth is required."
    exit 1
fi

mkdir -p $HOME/.docker || {
    echo "Error while creating docker credentials directory."
    exit 3
}

cat "$DOCKER_AUTH" > $HOME/.docker/config.json || {
    echo "Error while creating docker auth file."
    exit 4
}

docker network inspect $NETWORK_NAME > /dev/null 2>&1 || docker network create $NETWORK_NAME || {
    echo "Error while creating stable network."
    exit 5
}

docker image pull $IMAGE_NAME || {
    echo "Error while pulling image."
    exit 8
}

docker container rm -f $CONTAINER_NAME > /dev/null 2>&1 || {
    echo "Error while removing existing container."
    exit 9
}

bash -c "docker run -d \
         --restart always \
         --name $CONTAINER_NAME \
         --network $NETWORK_NAME \
         -p 80:80 \
         $IMAGE_NAME" || {
    echo "Error while running container."
    exit 10
}