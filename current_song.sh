##This script checks the current song being played by MPC and outputs the file. I've created an offset in order to reduce blank files.
#!/bin/sh
while true
do
  mpc current > current_song.txt
  if [ ! -s current_song.txt ]; then
    echo Subscribe > current_song.txt
  fi
  mpc idle player
done

while [ true ]
do
    if [ ! -s current_song.txt ]; then echo Subscribe > current_song.txt; fi
    sleep 100
done

