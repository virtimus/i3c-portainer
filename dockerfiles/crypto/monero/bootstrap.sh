#!/bin/bash
# https://github.com/monero-project/monero/tree/master
# https://getmonero.org/resources/user-guides/mining_with_xmrig_and_docker.html
cd /data
mkdir crypto
cd crypto

i3cTag=i3c/crypto/monero
i3cDataPrefix=/data/crypto/monero
 
git clone https://github.com/monero-project/monero.git
cd monero

  # Build using all available cores
  docker build -t $i3cTag .

  # or build using a specific number of cores (reduce RAM requirement)
  #docker build --build-arg NPROC=1 -t $i3cTag .

  # either run in foreground
  #docker run -it -v /data/crypto/monero/chain:/root/.bitmonero -v /data/crypto/monero/wallet:/wallet -p 18080:18080 monero

  # or in background
  docker run -d -v $i3cDataPrefix/chain:/root/.bitmonero -v $i3cDataPrefix/wallet:/wallet -p 18080:18080 $i3cTag
  docker run --name monero --entrypoint monerod -d -v /i3c/data/crypto/monero/chain:/root/.bitmonero -v /i3c/data/crypto/monero/wallet:/wallet -p 18080:18080 -p 127.0.0.1:18081:18081 i3c/crypto/monero --p2p-bind-ip=0.0.0.0 --p2p-bind-port=18080 --rpc-bind-ip=0.0.0.0 --rpc-bind-port=18081 --non-interactive --confirm-external-bind --log-level 1
  #docker run -d  -p 18080:18080 -p 127.0.0.1:18081:18081 -v /host/path/to/data/dir:/root/.bitmonero monero monerod --rpc-bind-ip=0.0.0.0 --confirm-external-bind --non-interactive
  
  docker run --name moneroxmlrminer --restart  unless-stopped --read-only -m 50M -c 512 bitnn/alpine-xmrig -o pool.supportxmr.com:5555 -u 4BBMYx18ctGd1eJP4so6inTfsHKN4Q71NYTPUWBkj9mP3iAW536UnSJNcFqN4f9A5UGy59Dcc2fEGLu2DtcmzUJeBFzDhzw -p virtimus:virtimus@gmail.com -k