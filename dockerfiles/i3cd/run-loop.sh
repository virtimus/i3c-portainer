#!/bin/bash
#/usr/bin/supervisord
#/usr/bin/supervisorctl

if [ ! -f /i3c/i3c.sh ]; then  
    cd / 
    git clone https://github.com/virtimus/i3c.git
    
    cd /i3c
    chmod -R a+x **/*.sh
fi

cd /i3c
npm install grunt
npm install -g grunt-cli
npm install -g grunt
	
cd /i3c
yarn install 
    
while ( true )
    do
    #//echo "Detach with Ctrl-p Ctrl-q. Dropping to shell"
    sleep 1000
    #/bin/bash
done
