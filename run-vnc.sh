#!/bin/bash

set -x
# Allow the re-run of the profile to succeed to fix LD_LIBRARY_PATH issue 
unset PROSPECTIVE_MQSI_BASE_FILEPATH

# Start the X server itself
vncserver -geometry 1600x1200

# Start the port forwarder on port 6080
#/usr/share/novnc/utils/launch.sh --vnc localhost:5901 &
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5901 &
