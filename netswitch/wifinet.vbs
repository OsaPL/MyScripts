set shell=CreateObject("Shell.Application")
' shell.ShellExecute "application", "arguments", "path", "verb", window
shell.ShellExecute "wifinet.bat",,, "runas", 0
set shell=nothing 