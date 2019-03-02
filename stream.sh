#!/bin/bash

sudo modprobe snd-aloop pcm_substreams=1
mpc play
mpc pause

FFMPEG=ffmpeg
VID=
STREAM_KEY=
TEXT=current_song.txt
COLOR="0xFFFFFF"
BCOLOR="0x000000"
INRES=1366x768 # input resolution
OUTRES=1920x1080 # output resolution
FPS=15 # target FPS
GOP=30 # i-frame interval, should be double of FPS,
GOPMIN=15 # min i-frame interval, should be equal to fps,
THREADS=4 # max 6
CBR=2100k # constant bitrate (should be between 1000k - 3000k)
QUALITY=veryfast # one of the many FFMPEG preset
AUDIO_RATE=44100
KEYINT=$(expr $FPS \* 3)

$FFMPEG -thread_queue_size 8024 -f alsa -ac 2 -i hw:Loopback,1,0 -fflags +genpts -r $FPS -stream_loop -1 -i $VID \
-vf drawtext="fontfile=/usr/share/fonts/truetype/slant.ttf:bordercolor=$BCOLOR: borderw=1: fontcolor=$COLOR:textfile=$TEXT:reload=1:y=10:x=5:fontsize=38" \
-vcodec libx264 -x264opts keyint=$KEYINT:min-keyint=$KEYINT:scenecut=-1 -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p \
-s $OUTRES -preset $QUALITY -c:a libfdk_aac -b:a 96k -ar 44100 -threads $THREADS -fflags nobuffer \
-bufsize $CBR -f flv "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY" \

2> log_stream.txt
