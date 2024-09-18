#!/bin/bash
killall plasmashell
# Sometimes this poops out, and needs to be cleared? Need to confirm if its actually the problem
#rm -r ~/.local/share/kactivitymanagerd/
sleep 5
kstart plasmashell
