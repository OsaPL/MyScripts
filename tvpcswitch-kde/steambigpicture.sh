#!/bin/bash
# turn on big picture -gamepadui -bigpicture
STEAMID=$(pidof steam)
kill $STEAMID
sleep 15
nohup steam -gamepadui -bigpicture &



