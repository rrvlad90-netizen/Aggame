@echo off
setlocal

set "ROOT=%~dp0"
set "GAME_DIR=D:\Games\Quake III"

set "PATH=%ROOT%code\win32\mod-sdk-setup\bin;%PATH%"

cd /d "%ROOT%code\game"
call game.bat

if errorlevel 1 goto error

if not exist "%GAME_DIR%\BigMod\vm" (
	mkdir "%GAME_DIR%\BigMod\vm"
)

copy /Y ^
	"%ROOT%code\game\vm\qagame.qvm" ^
	"%GAME_DIR%\BigMod\vm\qagame.qvm"

if errorlevel 1 goto error

echo QAGAME QVM BUILT AND COPIED
pause
exit /b 0

:error
echo QAGAME BUILD FAILED
pause
exit /b 1