#!/bin/bash

apt-get update
apt-get -y install git
cd $HOME
git clone https://github.com/fergbrain/stream_server.git
source stream_server/deploy.sh