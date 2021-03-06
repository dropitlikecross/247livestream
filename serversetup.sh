#Installs all the requirements for Ubuntu 18.04
apt-get -y install linux-generic

sudo apt-get update -qq && sudo apt-get

sudo apt-get update -qq && sudo apt-get -y install mpc mpd git

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
  libunistring-dev \
  libass-dev \
  libfdk-aac-dev
  
  sudo apt install ubuntu-restricted-addons
  
  sudo apt-get install libva-dev libmfx-dev
  
  sudo apt-get -y install autoconf automake build-essential libass-dev libtool pkg-config texinfo zlib1g-dev libva-dev cmake mercurial libdrm-dev libvorbis-dev libogg-dev git libx11-dev libperl-dev libpciaccess-dev libpciaccess0 xorg-dev intel-gpu-tools opencl-headers ocl-icd-*


Then add the Oibaf PPA, needed to install the latest development headers for libva:

sudo add-apt-repository ppa:oibaf/graphics-drivers
sudo apt-get update && sudo apt-get -y upgrade && sudo apt-get -y dist-upgrade


mkdir -p ~/ffmpeg_sources
cd ~/ffmpeg_sources && \
git -C aom pull 2> /dev/null || git clone --depth 1 https://aomedia.googlesource.com/aom && \
mkdir -p aom_build && \
cd aom_build && \
PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$HOME/ffmpeg_build" -DENABLE_SHARED=off -DENABLE_NASM=on ../aom && \
PATH="$HOME/bin:$PATH" make && \
make install


mkdir -p ~/ffmpeg_sources ~/bin
cd ~/ffmpeg_sources && \
wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
tar xjvf ffmpeg-snapshot.tar.bz2 && \
cd ffmpeg && \
PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="$HOME/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I$HOME/ffmpeg_build/include" \
  --extra-ldflags="-L$HOME/ffmpeg_build/lib" \
  --extra-libs="-lpthread -lm" \
  --bindir="$HOME/bin" \
  --enable-gpl \
  --enable-gnutls \
  --disable-libaom \
  --enable-libass \
  --enable-libfdk-aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libmfx \
  --enable-libdrm \
  --enable-gpl \
  --enable-nonfree && \
PATH="$HOME/bin:$PATH" make && \
make install && \
hash -r

sudo apt-get -y install python3-pip

pip3 install Flask


echo 'pcm.!default { type plug slave.pcm "hw:Loopback,0,0" }' >> ~/.asoundrc

ldconfig

source ~/.profile
