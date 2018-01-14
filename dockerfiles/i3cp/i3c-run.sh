docker run -d --name i3cp \
		-p 80:80 \
		-p 443:443\
		-v $i3cDataDir/i3cp/etc/nginx:/etc/nginx \
		-v $i3cDataDir/i3cp/www/:/usr/share/nginx/html \
		-v $i3cDataDir/i3cp:/data \
		-v $i3cHome:/i3c \
		-v $i3cLogDir/i3cp:/log \
		-e I3C_HOME=/i3c \
		-e I3C_DATA_DIR=/data \
		-e I3C_LOG_DIR=/log \
		i3c/i3cp:$i3cVersion 