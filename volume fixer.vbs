set shell=CreateObject("Shell.Application")
' shell.ShellExecute "application", "arguments", "path", "verb", window
shell.ShellExecute "volume fixer.bat",,, "runas", 0
set shell=nothing 