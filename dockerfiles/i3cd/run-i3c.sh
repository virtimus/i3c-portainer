#!/bin/bash

i3cHome='/i3c/i3c';	

if [ ! -f $i3cHome/i3c.sh ]; then  
    cd $i3cHome/.. 
    git clone https://github.com/virtimus/i3c.git
    
    cd $i3cHome/i3c
    chmod -R a+x **/*.sh
fi

ln -s $i3cHome/i3c.sh /i

cd $i3cHome
npm install grunt
npm install -g grunt-cli
npm install -g grunt
	
cd $i3cHome
yarn install 

cd $i3cHome 
grunt run-dev >> /log/grunt-run-dev.log &
