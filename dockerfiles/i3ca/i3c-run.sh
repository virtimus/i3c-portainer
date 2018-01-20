docker run -d --name i3ca \
		-p 3000:3000 \
		-v $i3cDataDir/i3ca:/data \
		-v $i3cHome:/i3c \
		-v $i3cLogDir/i3ca:/log \
		-e I3C_HOST=$i3cHost \
		-e I3C_HOME=/i3c \
		-e I3C_DATA_DIR=/data \
		-e I3C_LOG_DIR=/log \
		i3c/i3ca:$i3cVersion 
