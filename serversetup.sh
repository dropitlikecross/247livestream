apt-get install screen nano bzip2 mpg123 htop git
apt-get install autoconf automake build-essential libass-dev libfreetype6-dev libtheora-dev libtool libvorbis-dev pkg-config texinfo zlib1g-dev
apt-get install librtmp-dev libssl-dev libx264-dev libasound2-dev
apt-get install libomxil-bellagio-dev

apt-get install libfdk-aac-dev

apt-get install ffmpeg

ffmpeg -v

apt-get install linux-generic

modprobe snd-aloop pcm_substreams=1

echo 'pcm.!default { type plug slave.pcm 'hw:Loopback,0,0" }' >> ~/.asoundrc
