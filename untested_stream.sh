#variable definitions
GIF=/your/animated_gif.gif
INRES="1366x768" # input resolution
OUTRES="1366x768" # output resolution
FPS="15" # target FPS
GOP="30" # i-frame interval, should be double of FPS,
GOPMIN="15" # min i-frame interval, should be equal to fps,
THREADS="2" # max 6
CBR="1100k" # constant bitrate (should be between 1000k - 3000k)
QUALITY="veryfast" # one of the many FFMPEG preset
AUDIO_RATE="44100"
STREAM_KEY="" # your streaming key goes here
#to hide logs use= -loglevel quiet
ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i $GIF -i :0.0 -f alsa -i hw:Loopback,1,0 -f flv -ac 2 -ar $AUDIO_RATE \
-vcodec libx264 -keyint_min 3 -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p \
-s $OUTRES -preset $QUALITY -acodec aac -threads $THREADS \
-bufsize $CBR "rtmp://a.rtmp.youtube.com/live2/$STREAM_KEY"
