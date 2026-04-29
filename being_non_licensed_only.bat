@echo off
color A

:: ===============================
:: Check Admin Privileges
:: ===============================
openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /B
)

title aUtOtAsK - Non Licensed Devices

echo =====================================
echo  Running Non-Licensed Device Setup
echo =====================================
echo.

call :disable_update_and_defense
call :find_and_mount_iso
call :create_desktop_icons
call :change_region_and_timezone
call :download_and_install_softwares
call :run_setup_scripts
call :create_shortcuts
call :debloat_system

echo.
echo ===== COMPLETE =====
pause
exit /b


:: ==================================================
:: FUNCTIONS
:: ==================================================

:disable_update_and_defense
echo [*] Disable Windows Update & UAC
sc stop wuauserv > nul
sc config wuauserv start=disabled > nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" ^
 /v EnableLUA /t REG_DWORD /d 0 /f > nul
goto :eof


:find_and_mount_iso
echo [*] Searching for m.iso
for %%d in (c d e f g h i j k l m n p q r s t u v w x y z) do (
    if exist %%d:\m.iso (
        echo Mounting %%d:\m.iso
        powershell -Command "Mount-DiskImage -ImagePath '%%d:\m.iso'"
    )
)
timeout 1 > nul
cls
goto :eof


:create_desktop_icons
echo [*] Enable Desktop Icons
for %%G in (
"{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
"{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}"
"{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
"{645FF040-5081-101B-9F08-00AA002F954E}"
"{59031a47-3f72-44a7-89c5-5595fe6b30ee}"
) do (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v %%G /t REG_DWORD /d 0 /f > nul
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v %%G /t REG_DWORD /d 0 /f > nul
)
goto :eof


:change_region_and_timezone
echo [*] Set Region / Language / Timezone
powershell -command "Set-WinHomeLocation 0xe3"
powershell -command "Set-WinSystemLocale th-TH"
powershell -command "Set-Culture th-TH"
powershell -command "Set-TimeZone -Id 'SE Asia Standard Time'"
reg add "HKCU\Control Panel\International\Geo" /v Nation /d 227 /f > nul
reg add "HKCU\Control Panel\International\Geo" /v Name /d TH /f > nul
reg add "HKCU\Keyboard Layout\Toggle" /v "Language Hotkey" /d 4 /f > nul
goto :eof


:download_and_install_softwares
echo [*] Download Ninite
powershell -command "(New-Object Net.WebClient).DownloadFile( ^
'https://ninite.com/7zip-aimp-audacity-chrome-firefox-klitecodecs-notepadplusplus-sumatrapdf-vlc-winrar/ninite.exe', ^
'ninite.exe')"
start ninite.exe
timeout 2 > nul
goto :eof


:run_setup_scripts
echo [*] Search SETUP.CMD
for %%d in (c d e f g h i j k l m n p q r s t u v w x y z) do (
    if exist %%d:\SETUP.CMD (
        echo Running %%d:\SETUP.CMD
        start cmd /c "%%d:\SETUP.CMD"
    )
)
echo.
echo If setup finished, press any key...
pause > nul
goto :eof


:create_shortcuts
echo [*] Create Office Shortcuts
xcopy /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk" "%USERPROFILE%\Desktop" > nul
xcopy /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk" "%USERPROFILE%\Desktop" > nul
xcopy /q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk" "%USERPROFILE%\Desktop" > nul
goto :eof


:debloat_system
echo [*] Debloat System (Chris Titus)
powershell -Command "iwr -useb https://christitus.com/win | iex"
cls
goto :eof
