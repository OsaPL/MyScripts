#!/bin/bash

FILE=/home/osa/.speakersMode

HEADPHONESAUDIOSETUP='HyperX 7.1 Audio Analog Stereo'
SPEAKERSAUDIOSETUP='Built-in Audio Analog Stereo'

if test -f "$FILE"
then
    echo "$FILE exists."
    rm $FILE
    pwsh getIdsFrom-wpctl.ps1 "$HEADPHONESAUDIOSETUP"
else
    touch $FILE
    pwsh getIdsFrom-wpctl.ps1 "$SPEAKERSAUDIOSETUP"
fi
