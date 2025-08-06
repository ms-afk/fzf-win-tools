@echo off
:: fzfd: search a file by name and open it in File Explorer
fd --type f | fzf --ansi --preview "bat --style=full --color=always {}" --bind "enter:become:explorer.exe /select,{}"
