#!/bin/bash
name=ubuntu18_base
if [ "$1" != "" ];then
    name=$1
fi
pushd $name
docker build . -t $name --network host \
    --build-arg UNAME=$USER \
    --build-arg PASS=$USER \
    --build-arg UID=`id -u` \
    --build-arg GID=`id -g` 
popd
