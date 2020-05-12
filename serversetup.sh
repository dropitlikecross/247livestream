#Installs all the requirements for Ubuntu 18.04

apt-get update
apt-get -y install screen nano bzip2 mpc mpd htop git

sudo apt-get update -qq && sudo apt-get -y install \
  autoconf \
  automake \
  build-essential \
  cmake \
  git-core \
  libass-dev \
  libfreetype6-dev \
  libtool \
  libvorbis-dev \
  libxcb1-dev \
  pkg-config \
  texinfo \
  wget \
  zlib1g-dev \
  pkg-config \
  
sudo apt-get install libx264-dev libx265-dev libnuma-dev install libvpx-dev libfdk-aac-dev libmp3lame-dev libopus-dev  

apt-get -y install librtmp-dev libssl-dev libasound2-dev

sudo add-apt-repository ppa:jonathonf/ffmpeg-4

sudo apt-get update

apt-get -y install ffmpeg

apt-get -y install libomxil-bellagio-dev

apt-get -y install libfdk-aac-dev

apt-get -y install yasm

ffmpeg -version

apt-get -y install linux-generic

echo 'pcm.!default { type plug slave.pcm "hw:Loopback,0,0" }' >> ~/.asoundrc

ldconfig


