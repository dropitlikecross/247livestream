#!/bin/bash

sudo modprobe snd-aloop pcm_substreams=1
FFMPEG=/home/stream1/ffmpeg/ffmpeg
GIF=/mnt/streamstorage/video/chillnation/cardriving.gif
STREAM_KEY=y8k9-8zc3-3fzu-djr2
URL=rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY
FPS=30
KEYINT=$(expr $FPS \* 3)
TEXT=/tmp/currentsong.txt
COLOR="0xFFFFFF"
BCOLOR="0x000000"

$FFMPEG -thread_queue_size 512 -f alsa -ac 2 -i hw:Loopback,1,0 -fflags +genpts -ignore_loop 0 -r $FPS -i $GIF 2> ffmpeg_log.txt \
-vf drawtext="fontfile=/usr/share/fonts/truetype/freefont/FreeSans.ttf:bordercolor=$BCOLOR: borderw=1: fontcolor=$COLOR:textfile=$TEXT:reload=1:y=10:x=5" \
-vf "scale=1280:-1,format=yuv420p" \
-vcodec libx264 -x264opts keyint=$KEYINT:min-keyint=$KEYINT:scenecut=-1 -b:v 3500k \
-preset superfast -maxrate 3500k -bufsize 3500k  -s 1920x1080 \
-c:a libfdk_aac -b:a 128k -ar 44100 \
-f flv $URL
