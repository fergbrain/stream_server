#!/bin/bash

# Update the system
apt-get update
apt-get upgrade

# Add dotdeb to the package repo for nginx
echo "" | tee -a /etc/apt/sources.list
echo "# Add dotdeb" | tee -a /etc/apt/sources.list
echo "deb http://packages.dotdeb.org jessie all" | tee -a /etc/apt/sources.list
echo "deb-src http://packages.dotdeb.org jessie all" | tee -a /etc/apt/sources.list

# Add the dotdeb key
wget https://www.dotdeb.org/dotdeb.gpg -O /tmp/dotdeb.gpg
apt-key add /tmp/dotdeb.gpg

# Update the apt with the dotdeb repo
apt-get update
apt-get upgrade

# Install nginx-extras, which includes nginx-rtmp-module
apt-get install -y nginx-extras pkg-config build-essential yasm libmp3lame-dev libogg-dev libvorbis-dev libtheora-dev libaacs-dev libvpx-dev libx264-dev libxvidcore-dev libssl-dev pkg-config

#Based on: https://gist.github.com/fergbrain/fb50134a19405cfcc11f

export TMPDIR=/tmp



###########################################################
# faac 1.28
###########################################################
cd /usr/local/src
wget 'http://downloads.sourceforge.net/faac/faac-1.28.tar.gz' -O faac-1.28.tar.gz
tar -xzf faac-1.28.tar.gz
cd faac-1.28

# fix programming error
sed -i '126d' ./common/mp4v2/mpeg4ip.h

./configure
make          # 6 sec
make install

###########################################################
# rtmpdump 2.3
###########################################################
cd /usr/local/src
wget 'https://rtmpdump.mplayerhq.hu/download/rtmpdump-2.3.tgz' -O rtmpdump-2.3.tgz
tar -zxf rtmpdump-2.3.tgz
cd rtmpdump-2.3
make
make install

cd librtmp
make
make install


###########################################################
# ffmpeg 2.8
###########################################################
cd /usr/local/src
wget 'http://ffmpeg.org/releases/ffmpeg-2.8.tar.bz2'
tar -xjf ffmpeg-2.8.tar.bz2
cd ffmpeg-2.8

./configure \
--enable-libfaac --enable-libx264 --enable-libxvid \
--enable-nonfree --enable-gpl --enable-libmp3lame --enable-pthreads --enable-libvpx \
--enable-libvorbis --disable-mmx --enable-shared --enable-libtheora --enable-librtmp \
--pkg-config=pkg-config --enable-version3 --enable-pic

make          # 6.25 min
make install