#!/bin/bash

FFMPEG=ffmpeg
GIF=/your/animated_gif.gif
STREAM_KEY=<your stream key goes here>
URL=rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY
FPS=30
KEYINT=$(expr $FPS \* 3)
TEXT=/tmp/currentsong.txt
COLOR="0xFFFFFF"
BCOLOR="0x000000"

$FFMPEG -thread_queue_size 512 -f alsa -ac 2 -i hw:Loopback,1,0 -fflags +genpts -ignore_loop 0 -r $FPS -i $GIF \
-vf drawtext="fontfile=/usr/share/fonts/truetype/freefont/FreeSans.ttf:bordercolor=$BCOLOR: borderw=1: fontcolor=$COLOR:textfile=$TEXT:reload=1:y=10:x=5" \
-vcodec libx264 -x264opts keyint=$KEYINT:min-keyint=$KEYINT:scenecut=-1 -b:v 5000k \
-preset veryfast -s 1920x1080 \
-c:a libfdk_aac -b:a 96k -ar 44100 \
-f flv $URL
