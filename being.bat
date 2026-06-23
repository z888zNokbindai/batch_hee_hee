@echo off
color A

:: Check if the script is running with administrative privileges
openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    :: If not, relaunch the script as administrator
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /B
)

title aUtOtAsK
:main

echo Main Menu
echo ===========
echo a. For devices that have Windows licenses and Office licenses.
echo b. For devices that have Windows licenses.
echo c. For Non-Licensed Devices.
echo h. Activate 10/11 Home.
echo p. Activate 10/11 Pro.
echo o. Activate MS Office.
echo ===========
echo.
set /p choice=Please choose an option (a/b/c/h/p): 

if /i "%choice%"=="a" (
    echo You chose: For devices that have Windows licenses and Office licenses.
    call :devices_with_windows_and_office
    echo For devices that have Windows licenses and Office licenses Complete.
) else if /i "%choice%"=="b" (
    echo You chose: For devices that have Windows licenses.
    call :devices_with_windows_only
    echo For devices that have Windows licenses Complete.
) else if /i "%choice%"=="c" (
    echo You chose: For Non-Licensed Devices.
    call :non_licensed_devices
    echo For Non-Licensed Devices Complete.
) else if /i "%choice%"=="h" (
    echo You chose: Activate 10/11 Home.
    call :activate_home
    echo Activate 10/11 Home Complete.
) else if /i "%choice%"=="p" (
    echo You chose: Activate 10/11 Pro.
    call :activate_pro
    echo Activate 10/11 Pro Complete.
) else if /i "%choice%"=="o" (
    echo You chose: Activate MS Office..
    call :activate_office
    echo Activate MS Office. Complete.
) else (
    echo Invalid choice, please run the script again.
    goto :main
)
goto :main

:devices_with_windows_and_office
echo Running tasks for devices with Windows and Office licenses...
call :change_region_and_timezone
call :create_desktop_icons
call :create_shortcuts
call :download_and_install_softwares
call :debloat_system
goto :eof

:devices_with_windows_only
echo Running tasks for devices with Windows licenses...
call :find_and_mount_iso
call :create_desktop_icons
call :change_region_and_timezone
call :download_and_install_softwares
call :run_setup_scripts
call :create_shortcuts
call :debloat_system
goto :eof

:non_licensed_devices
echo Running tasks for non-licensed devices...
call :disable_update_and_defense
call :find_and_mount_iso
call :create_desktop_icons
call :change_region_and_timezone
call :download_and_install_softwares
call :run_setup_scripts
call :create_shortcuts
call :debloat_system
goto :eof

@REM :main
@REM call :disable_update_and_defense
@REM call :find_and_mount_iso
@REM call :create_desktop_icons
@REM call :change_region_and_timezone
@REM call :download_and_install_softwares
@REM call :run_setup_scripts
@REM call :create_shortcuts
@REM call :debloat_system

echo Complete.
pause > nul
goto :eof

:disable_update_and_defense
rem disable update and defense
sc stop wuauserv
sc config wuauserv start=disabled
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f 
goto :eof

:find_and_mount_iso
rem find m.iso and copy
for %%d in (c d e f g h i j k l m n p q r s t u v w x y z) do (
    if exist %%d:\m.iso (
        powershell -Command Mount-Diskimage -ImagePath "%%d:\m.iso"
    )
)
timeout 1 > nul
cls
goto :eof

:create_desktop_icons
rem create desktop icons
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{20D04FE0-3AEA-1069-A2D8-08002B30309D}" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{645FF040-5081-101B-9F08-00AA002F954E}" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d "0" /f
Reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu" /v "{59031a47-3f72-44a7-89c5-5595fe6b30ee}" /t REG_DWORD /d "0" /f
cls
timeout 1 > nul
goto :eof

:change_region_and_timezone
rem change region and time zone
powershell -command "Set-WinHomeLocation 0xe3"
powershell -command "Set-WinSystemLocale th-TH"
powershell -command "Set-Culture -CultureInfo th-TH"
powershell -command "Set-TimeZone -id 'SE Asia Standard Time'"
reg add "HKEY_CURRENT_USER\Control Panel\International\Geo" /v "Nation" /d "227" /f
reg add "HKEY_CURRENT_USER\Control Panel\International\Geo" /v "Name" /d "TH" /f
reg add "HKEY_CURRENT_USER\Keyboard Layout\Toggle" /v "Language Hotkey" /d "4" /f
goto :eof

:download_and_install_softwares
rem download and install softwares
powershell -command "(New-Object Net.WebClient).DownloadFile('https://ninite.com/7zip-aimp-audacity-chrome-firefox-klitecodecs-notepadplusplus-sumatrapdf-vlc-winrar/ninite.exe', 'ninite.exe')"
start ninite.exe
timeout 2 > nul
goto :eof

:run_setup_scripts
for %%d in (c d e f g h i j k l m n p q r s t u v w x y z) do (
    if exist %%d:\SETUP.CMD (
        start cmd /c "%%d:\SETUP.CMD"
    )
)


echo.
echo if installed.
echo press any key to create shortcut...
pause > nul
goto :eof

:create_shortcuts
xcopy /q /s "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk" "C:\Users\%username%\Desktop" > nul
xcopy /q /s "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk" "C:\Users\%username%\Desktop" > nul
xcopy /q /s "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk" "C:\Users\%username%\Desktop" > nul
goto :eof

:debloat_system
rem debloat
powershell -Command "iwr -useb https://christitus.com/win | iex"
cls
goto :eof

:activate_home
echo Activate Windows 10,11 Home
slmgr /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
slmgr /skms kms8.msguides.com
slmgr /ato
goto :eof

:activate_pro
echo Activate Windows 10,11 Home
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
slmgr /skms kms8.msguides.com
slmgr /ato
goto :eof

:activate_office
powershell -Command "irm https://get.activated.win | iex"
    )
)
