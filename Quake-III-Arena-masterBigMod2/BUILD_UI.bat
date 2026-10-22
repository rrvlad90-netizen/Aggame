@echo off
setlocal

set "ROOT=%~dp0"
set "GAME_DIR=D:\Games\Quake III"

set "PATH=%ROOT%code\win32\mod-sdk-setup\bin;%PATH%"

cd /d "%ROOT%code\q3_ui"
call q3_ui.bat

if errorlevel 1 goto error

if not exist "%GAME_DIR%\BigMod\vm" mkdir "%GAME_DIR%\BigMod\vm"

copy /Y "%ROOT%code\q3_ui\vm\ui.qvm" "%GAME_DIR%\BigMod\vm\ui.qvm"

if errorlevel 1 goto error

echo UI QVM BUILT AND COPIED
pause
exit /b 0

:error
echo UI BUILD FAILED
pause
exit /b 1