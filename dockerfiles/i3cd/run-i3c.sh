#!/bin/bash

if [ ! -f /i3c/i3c.sh ]; then  
    cd / 
    git clone https://github.com/virtimus/i3c.git
    
    cd /i3c
    chmod -R a+x **/*.sh
fi

ln -s /i3c/i3c.sh /i

cd /i3c
npm install grunt
npm install -g grunt-cli
npm install -g grunt
	
cd /i3c
yarn install 

cd /i3c 
grunt run-dev >> /log/grunt-run-dev.log &
