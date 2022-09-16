#!/bin/bash
name=zl_dev16
if [ "$1" != "" ];then
    name=$1
fi
docker run  -e COLUMNS="$COLUMNS" -e LINES="$LINES" -it --network host --gpus all \
    -v $HOME:/$HOME \
    -v /data:/data \
    -v /mnt/nvme:/mnt/nvme \
    $name \

#docker run  -e COLUMNS="$COLUMNS" -e LINES="$LINES" -it --network host --gpus all \
#    -v $HOME/g/ByteTrack/:/workspace/ByteTrack \
#    $name \

