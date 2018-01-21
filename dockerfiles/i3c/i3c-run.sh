#!/bin/sh
#-v /tmp/portainer:/data \
#-v /tmp/portainer:/data \
#-v $i3cDataDir/i3c:/data \
#	-v /tmp/portainer:/data \
#-d /data
commandwp = ${@:2};
if [ "x$commandwp" = "x" ]; then	
	commandwp='/app/portainer-linux-amd64 --no-analytics';	
fi

docker run -d --name i3c \
	-p 9000:9000 \
	-v $i3cDataDir/i3c:/data2 \
	-v $i3cHome:/i3c \
	-v $i3cLogDir/i3c:/log \
	-v $i3cHome/dist:/app \
	-v /var/run/docker.sock:/var/run/docker.sock:z \
	-e I3C_HOST=$i3cHost \
	-e I3C_HOME=/i3c \
	-e I3C_DATA_DIR=/data \
	-e I3C_LOG_DIR=/log \
	i3c/i3c:$i3cVersion $commandwp