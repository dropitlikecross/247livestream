#!/bin/bash

sudo modprobe snd-aloop pcm_substreams=1
FFMPEG=ffmpeg
GIF=/mnt/streamstorage/video/gamingstream/narutocity.gif
STREAM_KEY=
TEXT=/tmp/current_song.txt
COLOR="0xFFFFFF"
BCOLOR="0x000000"
INRES=1366x768 # input resolution
OUTRES=1366x768 # output resolution
FPS=15 # target FPS
GOP=30 # i-frame interval, should be double of FPS,
GOPMIN=15 # min i-frame interval, should be equal to fps,
THREADS=2 # max 6
CBR=1100k # constant bitrate (should be between 1000k - 3000k)
QUALITY=veryfast # one of the many FFMPEG preset
AUDIO_RATE=44100
KEYINT=$(expr $FPS \* 3)

$FFMPEG -thread_queue_size 1024 -f alsa -ac 2 -i hw:Loopback,1,0 -fflags +genpts -ignore_loop 0 -r $FPS -i $GIF \
-vf drawtext="fontfile=/usr/share/fonts/truetype/freefont/FreeSans.ttf:bordercolor=$BCOLOR: borderw=1: fontcolor=$COLOR:textfile=$TEXT:reload=1:y=10:x=5" \
-vcodec libx264 -x264opts keyint=$KEYINT:min-keyint=$KEYINT:scenecut=-1 -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p \
-s $OUTRES -preset $QUALITY -acodec aac -threads $THREADS -fflags nobuffer \
-bufsize $CBR -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
