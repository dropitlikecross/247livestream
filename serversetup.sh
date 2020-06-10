#Installs all the requirements for Ubuntu 18.04

apt-get update
apt-get -y install screen nano bzip2 mpc mpd htop git

sudo apt-get update -qq && sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  nasm \
  libfreetype6-dev \
  libvorbis-dev \
  libxcb1-dev \
  libx264-dev \
  libx265-dev \
  libnuma-dev \
  libvpx-dev \
  libfdk-aac-dev \
  libmp3lame-dev \
  libopus-dev \
  gnutls-bin \
  libasound2-dev \
  librtmp-dev \
  libssl-dev \
  libomxil-bellagio-dev \
  libunistring-dev 



ffmpeg -version

apt-get -y install linux-generic

echo 'pcm.!default { type plug slave.pcm "hw:Loopback,0,0" }' >> ~/.asoundrc

ldconfig


