#!/bin/bash
# https://github.com/monero-project/monero/tree/master
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
  docker run -it -d -v $i3cDataPrefix/chain:/root/.bitmonero -v i3cDataPrefix/wallet:/wallet -p 18080:18080 $i3cTag