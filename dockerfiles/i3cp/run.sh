#!/bin/bash

if [ ! -f /etc/nginx/nginx.conf ]; then  
  cp /nginx.conf /etc/nginx/nginx.conf
fi

nginx -g "daemon off;"