#!/bin/bash
# turn on big picture -gamepadui -bigpicture
kdialog --passivepopup 'Launching into Steam Bigpicture' 20
STEAMID=$(pidof steam)
kill $STEAMID
sleep 15
nohup gamescope -w 3840 -h 2160 -r 120 -f -e --hdr-enabled --hdr-itm-enable -- steam -gamepadui -bigpicture &
#nohup steam -gamepadui -bigpicture &



