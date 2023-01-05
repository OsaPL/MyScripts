sudo systemctl stop warforkServer
steamcmd  +@NoPromptForPassword 1 +login <user> <pass> +app_update 671610 validate +quit
sudo systemctl start warforkServer
