#!/bin/bash

export VERSION=`cat latest`
export latest=`curl -Is https://hub.docker.com/v2/repositories/richarvey/awscli/tags/$(cat latest)/ | head -n 1|cut -d$' ' -f2`

# Set up environment
docker version
docker buildx ls
docker buildx create --name awsclibuilder
docker buildx use awsclibuilder

if [ ${latest} == "200" ]; then
    echo "Build Exists: Nothing to do!"
    exit 0
else
    echo "Building: awscli"
    docker buildx build --platform linux/amd64,linux/arm64 -t "richarvey/awscli:${VERSION}" -t richarvey/awscli:latest --push .

# Build Slim
    echo "Building: awscli:slim"
    docker buildx build --platform linux/amd64 -t "richarvey/awscli:${VERSION}-slim" -t richarvey/awscli:slim -f Dockerfile-slim --push .

fi
