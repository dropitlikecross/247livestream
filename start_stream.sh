#Script to check if the stream script has terminated and to start it again if it has.
#!/bin/bash

trap "kill 0" SIGINT

while :
do
   ./stream.sh
   echo "Stream has Crashed"
done &

while :
do
   ./current_song.sh
   echo "Current Song has Crashed"
done
