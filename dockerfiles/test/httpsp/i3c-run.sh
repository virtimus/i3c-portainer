#!/bin/bash
docker run -d --name httpsp \
		-p 80:80 \
		-p 443:443 \
		-v $i3cDataDir/httpsp:/data \
		-v $i3cDataDir/httpsp/ssl_certs:/var/lib/https-portal \
		-v $i3cDataDir/httpsp/vhosts:/var/www/vhosts \
		-v $i3cHome:/i3c \
		-v $i3cLogDir/httpsp:/log \
		-v /var/run/docker.sock:/var/run/docker.sock:ro \
		-e I3C_HOME=/i3c \
		-e I3C_DATA_DIR=/data \
		-e I3C_LOG_DIR=/log \
		i3c/httpsp:$i3cVersion 