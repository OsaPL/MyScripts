#!/bin/bash

FILE=/home/osa/.pcmode

TVVIDEOSETUP="output.HDMI-A-1.enable output.HDMI-A-2.disable output.DP-1.disable"
TVAUDIOSETUP='HDA ATI HDMI Digital Stereo (HDMI 2)'

PCVIDEOSETUP="output.HDMI-A-1.disable output.DP-1.enable output.DP-1.primary output.HDMI-A-2.enable"
PCAUDIOSETUP='Built-in Audio Analog Stereo'
echo $PCAUDIOSETUP

# bt service may need a restart to work after adapter change
#sudo systemctl restart bluetooth

if test -f "$FILE"; then
    echo "$FILE exists."
fi

if test -f "$FILE"
then
    rm $FILE
    # tv mode
    kscreen-doctor $TVVIDEOSETUP
    # switch audio
    pwsh ./getIdsFrom-wpctl.ps1 "$TVAUDIOSETUP"
    # turn on big picture -gamepadui -bigpicture
    STEAMID=$(pidof steam)
    kill $STEAMID
    sleep 15
    nohup steam -gamepadui -bigpicture &
else
    touch $FILE
    # pc mode
    # switch displays
    kscreen-doctor $PCVIDEOSETUP 
    # switch audio 
    pwsh ./getIdsFrom-wpctl.ps1 "$PCAUDIOSETUP"
    # kill big picture and return to normal steam
    STEAMID=$(pidof steam)
    kill $STEAMID
    sleep 15
    nohup steam &
fi