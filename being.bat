@echo off
color A

:: Check if the script is running with administrative privileges
openfiles >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Requesting administrative privileges...
    powershell -ProcessMitigation -SystemBypass "Start-Process cmd -ArgumentList '/c \"%~f0\"' -Verb RunAs"
    exit /B
)

title aUtOtAsK
:main
cls
echo Main Menu
echo ===========
echo a. For devices that have Windows licenses and Office licenses.
echo b. For devices that have Windows licenses.
echo c. For Non-Licensed Devices.
echo h. Activate 10/11 Home.
echo p. Activate 10/11 Pro.
echo o. Activate MS Office.
echo q. Exit
echo ===========
echo.
set /p choice=Please choose an option (a/b/c/h/p/o/q): 

if /i "%choice%"=="a" (
    echo You chose: For devices that have Windows licenses and Office licenses.
    call :devices_with_windows_and_office
    echo Process Complete.
    pause & goto :main
) else if /i "%choice%"=="b" (
    echo You chose: For devices that have Windows licenses.
    call :devices_with_windows_only
    echo Process Complete.
    pause & goto :main
) else if /i "%choice%"=="c" (
    echo You chose: For Non-Licensed Devices.
    call :non_licensed_devices
    echo Process Complete.
    pause & goto :main
) else if /i "%choice%"=="h" (
    call :activate_home
    pause & goto :main
) else if /i "%choice%"=="p" (
    call :activate_pro
    pause & goto :main
) else if /i "%choice%"=="o" (
    call :activate_office
    pause & goto :main
) else if /i "%choice%"=="q" (
    exit /B
) else (
    echo Invalid choice, please try again.
    timeout 2 > nul
    goto :main
)

:devices_with_windows_and_office
call :change_region_and_timezone
call :create_desktop_icons
call :download_and_install_softwares
call :create_shortcuts
call :debloat_system
goto :eof

:devices_with_windows_only
call :find_and_mount_iso
call :create_desktop_icons
call :change_region_and_timezone
call :download_and_install_softwares
call :run_setup_scripts
call :create_shortcuts
call :debloat_system
goto :eof

:non_licensed_devices
call :disable_update_and_defense
call :find_and_mount_iso
call :create_desktop_icons
call :change_region_and_timezone
call :download_and_install_softwares
call :run_setup_scripts
call :create_shortcuts
call :debloat_system
goto :eof

:disable_update_and_defense
rem ปิด Service ตามความจำเป็น (ลบการตั้งค่า EnableLUA=0 ออกเพื่อความปลอดภัยของ OS)
sc stop wuauserv
sc config wuauserv start=disabled
goto :eof

:find_and_mount_iso
for %%d in (c d e f g h i j k l m n p q r s t u v w x y z) do (
    if exist %%d:\m.iso (
        powershell -Command "Mount-DiskImage -ImagePath '%%d:\m.iso'"
    )
)
timeout 1 > nul
goto :eof

:create_desktop_icons
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
goto :eof

:change_region_and_timezone
powershell -command "Set-WinHomeLocation 0xe3; Set-WinSystemLocale th-TH; Set-Culture th-TH; Set-TimeZone -id 'SE Asia Standard Time'"
reg add "HKEY_CURRENT_USER\Control Panel\International\Geo" /v "Nation" /d "227" /f
reg add "HKEY_CURRENT_USER\Control Panel\International\Geo" /v "Name" /d "TH" /f
reg add "HKEY_CURRENT_USER\Keyboard Layout\Toggle" /v "Language Hotkey" /d "4" /f
goto :eof

:download_and_install_softwares
powershell -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('https://ninite.com/7zip-aimp-audacity-chrome-firefox-klitecodecs-notepadplusplus-sumatrapdf-vlc-winrar/ninite.exe', '%TEMP%\ninite.exe')"
start "" "%TEMP%\ninite.exe"
goto :eof

:run_setup_scripts
for %%d in (c d e f g h i j k l m n p q r s t u v w x y z) do (
    if exist %%d:\SETUP.CMD (
        start "" cmd /c "%%d:\SETUP.CMD"
    )
)
echo Please wait for SETUP.CMD to finish if executed...
pause
goto :eof

:create_shortcuts
set "DESKTOP_PATH=%USERPROFILE%\Desktop"
if exist "%USERPROFILE%\OneDrive\Desktop" set "DESKTOP_PATH=%USERPROFILE%\OneDrive\Desktop"

if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk" xcopy /q /y "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk" "%DESKTOP_PATH%\" > nul
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk" xcopy /q /y "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk" "%DESKTOP_PATH%\" > nul
if exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk" xcopy /q /y "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk" "%DESKTOP_PATH%\" > nul
goto :eof

:debloat_system
powershell -Command "iwr -useb https://christitus.com/win | iex"
goto :eof

:activate_home
echo Activate Windows 10/11 Home...
slmgr /ipk TX9XD-98N7V-6WMQ6-BX7FG-H8Q99
slmgr /skms kms8.msguides.com
slmgr /ato
goto :eof

:activate_pro
echo Activate Windows 10/11 Pro...
slmgr /ipk W269N-WFGWX-YVC9B-4J6C9-T83GX
slmgr /skms kms8.msguides.com
slmgr /ato
goto :eof

:activate_office
echo Running Office Activation...
powershell -Command "irm https://get.activated.win | iex"
goto :eof
