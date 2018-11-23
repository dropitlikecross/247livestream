#Script to check if the stream script has terminated and to start it again if it has.
#!/bin/bash

trap "exit" SIGINT

while true :
do
  /home/stream/stream.sh
  echo "Stream has Crashed"
done
