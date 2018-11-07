#!/bin/bash

trap "exit" SIGINT

while true :
do
  /home/stream/stream.sh
  echo "some crash"
done
