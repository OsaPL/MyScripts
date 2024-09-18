#!/bin/bash

FILE=/home/osa/.pcmode

# use `kscreen-doctor -o` to get video devices ids
TVVIDEOSETUP="output.HDMI-A-3.enable output.HDMI-A-1.disable output.DP-1.disable output.HDMI-A-3.hdr.enable"
# use `wpctl status` to get audio sink name
TVAUDIOSETUP='Navi 31 HDMI/DP Audio Digital Stereo (HDMI)'

PCVIDEOSETUP="output.HDMI-A-3.disable output.DP-1.enable output.DP-1.primary output.HDMI-A-1.enable"
PCAUDIOSETUP='Built-in Audio Analog Stereo'

# bt service may need a restart to work after adapter change
#sudo systemctl restart bluetooth

if test -f "$FILE"; then
    echo "$FILE exists."
fi

if test -f "$FILE"
then
    kdialog --passivepopup 'Switching to TV Mode' 20
    rm $FILE
    # tv mode
    kscreen-doctor $TVVIDEOSETUP

    # switch audio
    pwsh ./getIdsFrom-wpctl.ps1 "$TVAUDIOSETUP"
else
    kdialog --passivepopup 'Switching to PC Mode' 20
    touch $FILE
    # first we switch audio, cause analog is always available
    pwsh ./getIdsFrom-wpctl.ps1 "$PCAUDIOSETUP"

    # pc mode
    # switch displays
    kscreen-doctor $PCVIDEOSETUP 

fi
