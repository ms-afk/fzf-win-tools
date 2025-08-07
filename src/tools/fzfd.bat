@echo off
:: fzfd: search a file by name and open it in File Explorer
set tools=%~dp0
set utilities=%tools%..\utilities\
fd --type f | fzf --ansi --multi^
 --preview "bat --style=full --color=always {}"^
 --bind "enter:execute-silent(explorer.exe /select,{})"^
 --bind "ctrl-o:execute-silent(\"%utilities%exec-pwsh.bat\" \"%utilities%explore-multi.ps1\" {+})+clear-multi"
