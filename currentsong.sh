#!/bin/sh
while [ true ]
do
  mpc current > current_song.txt
  mpc idle player
done
