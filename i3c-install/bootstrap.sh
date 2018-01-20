#!/bin/sh
echo "------------------------------------------------------------------------"
echo "Runing: i3c-install/bootstrap.sh ..."
set
echo "------------------------------------------------------------------------"
CONTAINER=i3cd
RUNNING=$(docker inspect --format="{{.State.Running}}" $CONTAINER 2> /dev/null)

#if [ $? -eq 1 ]; then
#  echo "UNKNOWN - $CONTAINER does not exist."
#  exit 3
#fi
 
if [ "$RUNNING" == "true" ]; then
    echo "FINAL - $CONTAINER is running."
    exit 0
fi

i3cHome='/i3c/i3c';	

ln -s $i3cHome/i3c.sh /i

echo "-------------------------"
echo "/i rebuild base/alpine ..."
/i rebuild base/alpine

echo "-------------------------"
echo "/i rebuild i3c ..."
/i rebuild i3c

echo "-------------------------"
echo "/i rebuild i3cp ..."
/i rebuild i3cp

if [ ! "x$PWD_SESSION_ID" = "x" ]; then
  exHostIp=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' i3cp);
  exHostUrl='ip'$exHostIp'-'$PWD_SESSION_ID'-80.direct.labs.play-with-docker.com'
  echo 'exHostURL:'$exHostUrl
  exit 0
fi

echo "-------------------------"
echo "/i rerun i3cp ..."
/i rerun i3cp 

echo "-------------------------"
echo "/i rebuild i3cd ..."
/i rebuild i3cd 
#>> /log/i3cd-rebuild.log

echo "-------------------------"
echo "/i rerun i3cd ..."
/i rerun i3cd 
#>> /log/i3cd-rerun.log
#cd $(dirname $0)

exec_in() { docker exec $@; }

echo "-------------------------"
echo "exec_in i3cd \"/run-i3c.sh\""
exec_in i3cd "/run-i3c.sh"

echo "------------------------------------------------------------------------"
echo "End: i3c-install/bootstrap.sh ..."
echo "------------------------------------------------------------------------"
