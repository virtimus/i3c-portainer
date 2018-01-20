#!/bin/bash
#		-v /var/run/docker.sock:/var/run/docker.sock \
#		-p 8500:8500 \
docker run -d --name consul \
		-v $i3cDataDir/consul:/data \
		-v $i3cHome:/i3c \
		-v $i3cLogDir/consul:/log \
		-e I3C_HOME=/i3c \
		-e I3C_DATA_DIR=/data \
		-e I3C_LOG_DIR=/log \
		-e VIRTUAL_HOST=consul.dtb.h \
		-e VIRTUAL_PORT=8500 \
		-e VIRTUAL_PROTO=http \
		i3c/consul:$i3cVersion 