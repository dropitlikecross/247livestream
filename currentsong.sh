#!/bin/sh
while [ true ]
do
  mpc current > /tmp/current_song.txt
  mpc idle player
done
