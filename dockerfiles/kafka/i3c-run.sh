#!/bin/bash
# https://github.com/virtimus/i3c-kafka.git

#currDir=$(pwd); 
#cd $i3cDfDir/$1
#mkdir .tmp
#cd .tmp

#git clone https://github.com/virtimus/i3c-kafka.git

#cd i3c-kafka

#docker-compose up -d

#-v /var/run/docker.sock:/var/run/docker.sock:ro \
#
cName=kafka
iName=kafka  
docker run -d --name $cName \
		-p 9092:9092 \
		--dns=$(ip i3cp) \
		-v $i3cDataDir/$iName:/data \
		-v $i3cHome:/i3c \
		-v $i3cLogDir/$iName:/log \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e VIRTUAL_HOST=$cName.$i3cHost \
		-e VIRTUAL_PORT=9092 \
		-e I3C_HOST=$i3cHost \
		-e I3C_HOME=/i3c \
		-e I3C_DATA_DIR=/data \
		-e I3C_LOG_DIR=/log \
      	-e KAFKA_ADVERTISED_HOST_NAME=$i3cHost \
      	-e KAFKA_ZOOKEEPER_CONNECT=zookeeper.$i3cHost \
		i3c/$iName:$i3cVersion