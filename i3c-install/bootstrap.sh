#!/bin/sh

CONTAINER=i3cd
RUNNING=$(docker inspect --format="{{.State.Running}}" $CONTAINER 2> /dev/null)

#if [ $? -eq 1 ]; then
#  echo "UNKNOWN - $CONTAINER does not exist."
#  exit 3
#fi
 
if [ "$RUNNING" == "true" ]; then
    echo "CRITICAL - $CONTAINER is running."
    exit 0
fi

ln -s /i3c/i3c.sh /i

/i rebuild i3cd

/i rerun i3cd
#cd $(dirname $0)

#exec_in() { docker exec $@; }
#exec_in i3cd "/run-i3c.sh &"
