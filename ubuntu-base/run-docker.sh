#!/usr/bin/env bash

#set -x

xhost +local:docker

IMG=rookiecj/docker-ubuntu-base:16.04
TAG=docker-ubuntu-base

#echo "Searching for Docker image ..."
#DOCKER_IMAGE_ID=$(docker images --format="{{.ID}}" $TAG | head -n 1)
#echo "Found and using ${DOCKER_IMAGE_ID}"

USER_UID=$(id -u)

mkdir -p docker-share

echo you can gracefully request to shut down using 
echo docker stop $TAG

# --interactive , -i        Keep STDIN open even if not attached
# --tty , -t      Allocate a pseudo-TTY
# --privileged      Give extended privileges to this container
#  --sysctl net.ipv4.ip_forward=1
#  --device=/dev/input 

docker run -it \
  --volume=/tmp/.X11-unix:/tmp/.X11-unix \
  --volume=/run/user/${USER_UID}/pulse:/run/user/1000/pulse \
  --env=DISPLAY=${DISPLAY} \
  --env=LIBUSB_DEBUG=1 \
  --group-add=plugdev \
  --group-add=video \
  --rm \
  --volume=$PWD/docker-share:/docker \
  --name $TAG \
  ${IMG} \
  ${@}

# docker run -it ${IMG} $TAG ps all
# F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMMAND
# 4  1000     1     0  20   0   4368   736 sigtim Ss   ?          0:00 /tini -- ps
# 0  1000     7     1  20   0  25976  1436 -      R+   ?          0:00 ps all


# docker run -it ${IMG} $TAG 
# cj@846d3fa04b65:/$ ps all   
# F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMMAND
# 4  1000     1     0  20   0   4368   788 sigtim Ss   ?          0:00 /tini -- /bin/bash
# 0  1000     7     1  20   0  18228  3248 wait   S    ?          0:00 /bin/bash
# 0  1000    14     7  20   0  25976  1428 -      R+   ?          0:00 ps all

#
# using 'exec' the parent of spawned processes is not '1:tini', but was '0'
# docker exec -t $TAG ps all
# F   UID   PID  PPID PRI  NI    VSZ   RSS WCHAN  STAT TTY        TIME COMMAND
# 4  1000     1     0  20   0   4368   696 sigtim Ss   ?          0:00 /tini -- /b
# 0  1000     7     1  20   0  18228  3128 wait_w S+   ?          0:00 /bin/bash
# 4  1000    28     0  20   0  36664  3116 poll_s Ss+  ?          0:00 top -H
# 4  1000    34     0  20   0  25976  1500 -      Rs+  ?          0:00 ps all


xhost -local:docker

