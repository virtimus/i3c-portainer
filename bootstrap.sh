#!/bin/sh
echo "------------------------------------------------------------------------"
echo "Runing: i3c/bootstrap.sh ..."
echo "------------------------------------------------------------------------"
CONTAINER=i3cd
RUNNING=$(docker inspect --format="{{.State.Running}}" $CONTAINER 2> /dev/null)

if [ "$RUNNING" == "true" ]; then
    echo "I3C_FINAL - $CONTAINER is running."
    exit 0
fi

mkdir /i3c
cd /i3c
git clone https://github.com/virtimus/i3c.git
cd i3c
./i3c-install/bootstrap.sh

echo "------------------------------------------------------------------------"
echo "Ended: i3c/bootstrap.sh ."
echo "------------------------------------------------------------------------"
