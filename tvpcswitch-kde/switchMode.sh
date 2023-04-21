#!/bin/bash

FILE=/home/osa/.pcmode
# bt service needs a restart to work after adapter change
sudo systemctl restart bluetooth

if test -f "$FILE"; then
    echo "$FILE exists."
fi

if test -f "$FILE"
then
    rm $FILE
    # tv mode
    kscreen-doctor output.HDMI-A-1.enable output.HDMI-A-2.disable output.DP-1.disable
    # switch audio TODO! These should be automatic probably, atm just use `wpctl status` and get audio sink IDs from there
    wpctl set-default 45
    # turn on big picture -gamepadui -bigpicture
    STEAMID=$(pidof steam)
    kill $STEAMID
    sleep 15
    nohup steam -gamepadui -bigpicture &
else
    touch $FILE
    # pc mode
    # switch displays
    kscreen-doctor output.HDMI-A-1.disable output.DP-1.enable output.DP-1.primary output.HDMI-A-2.enable
    # switch audio TODO! These should be automatic probably, atm just use `wpctl status` and get audio sink IDs from there
    wpctl set-default 48
    # kill big picture and return to normal steam
    STEAMID=$(pidof steam)
    kill $STEAMID
    sleep 15
    nohup steam &
fi




