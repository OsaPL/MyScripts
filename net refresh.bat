@echo off
echo "Network troubleshooting script, highly advised to reboot PC after it's done"
winsock reset
timeout 3
netsh int ip reset
timeout 3
ipconfig /release 
timeout 3
ipconfig /renew
timeout 3
ipconfig /flushdns