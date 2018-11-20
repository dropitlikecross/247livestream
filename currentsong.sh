#!/bin/sh
while [ true ]
do
  mpc current > current_song.txt
        if [ ! -s current_song.txt ]; then echo Subscribe > current_song.txt; fi
  mpc idle player
done
