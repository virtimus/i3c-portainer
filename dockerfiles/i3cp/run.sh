#!/bin/bash

if [ ! -f /etc/nginx/nginx.conf ]; then  
  cp /nginx.conf /etc/nginx/nginx.conf
fi

echo "Starting nginx...."

nginx -g "daemon off;"