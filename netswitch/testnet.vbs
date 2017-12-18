set shell=CreateObject("Shell.Application")
' shell.ShellExecute "application", "arguments", "path", "verb", window
shell.ShellExecute "testnet.bat",,, "runas", 0
set shell=nothing 