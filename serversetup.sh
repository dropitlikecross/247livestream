apt-get update
apt-get -y install screen nano bzip2 mpc mpd htop git
apt-get -y install autoconf automake build-essential libass-dev libfreetype6-dev libtheora-dev libtool libvorbis-dev pkg-config texinfo zlib1g-dev
apt-get -y install librtmp-dev libssl-dev libx264-dev libasound2-dev
apt-get -y install libomxil-bellagio-dev

apt-get -y install libfdk-aac-dev

apt-get -y install yasm

apt-get -y install ffmpeg

ffmpeg -version

apt-get -y install linux-generic

echo 'pcm.!default { type plug slave.pcm "hw:Loopback,0,0" }' >> ~/.asoundrc

ldconfig
