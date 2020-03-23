#!/bin/bash
imageName=${1#quay.io/}
docker pull quay.azk8s.cn/$imageName
docker tag quay.azk8s.cn/$imageName quay.io/$imageName
docker rmi quay.azk8s.cn/$imageName
