tasklist|>nul find /i "Steam.exe"
if errorlevel 1 (
start E:\Steam\Steam.exe -bigpicture
) else (
taskkill /F /IM Steam.exe
start E:\Steam\Steam.exe -bigpicture
)