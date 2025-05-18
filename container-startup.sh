#!/bin/bash

#set -x
# Allow the re-run of the profile to succeed to fix LD_LIBRARY_PATH issue 
unset PROSPECTIVE_MQSI_BASE_FILEPATH

export HOME=/home/aceuser
chmod -R 777 /home/aceuser 2>/dev/null
cd /home/aceuser && tar -xf /tmp/home-aceuser.tar
chmod -R 777 /home/aceuser 2>/dev/null

set -e

mkdir -p /home/aceuser/.vnc

echo "$VNCPASSWORD" | vncpasswd -f > /home/aceuser/.vnc/passwd
chmod 600 /home/aceuser/.vnc/passwd

/usr/local/bin/run-vnc.sh

echo "Sleeping to let the X server start"
sleep 10

echo "Starting a shell on the X display"
export DISPLAY=:1
xsetroot -solid black
xterm -fg white -bg black -sb -sl 1000 -e bash &

echo "Sleeping to keep container running"
sleep 10000000
