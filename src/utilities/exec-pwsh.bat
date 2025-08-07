@echo off
:: Execute powershell file
Powershell.exe -ExecutionPolicy RemoteSigned -File %*
