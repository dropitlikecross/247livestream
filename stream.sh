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


$FFMPEG -f alsa -ac 2 -i hw:Loopback,1,0 -fflags +genpts -ignore_loop 0 -r $FPS -i $GIF \
-vf drawtext="fontfile=/usr/share/fonts/truetype/freefont/FreeSans.ttf:bordercolor=$BCOLOR: borderw=1: fontcolor=$COLOR:textfile=$TEXT:reload=1:y=10:x=5" \
-vcodec libx264 -b:v 1000k \
-preset veryfast -pix_fmt yuv420p -s 1920x1080 \
-c:a libfdk_aac -b:a 96k -ar 48000 \
-f flv $URL

