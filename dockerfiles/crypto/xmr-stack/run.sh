#!/bin/bash

i3cTag=i3c/crypto/xmr-staks
cd /i3c/data/crypto
git clone https://github.com/fireice-uk/xmr-stak

docker build -t $i3cTag alpine:latest