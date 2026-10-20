@echo off
setlocal

set "ROOT=%~dp0"
set "GAME_DIR=D:\Games\Quake III"

set "PATH=%ROOT%code\win32\mod-sdk-setup\bin;%PATH%"

del /q "%ROOT%code\cgame\vm\cgame.qvm" 2>nul

cd /d "%ROOT%code\cgame"
call cgame.bat

if not exist "%ROOT%code\cgame\vm\cgame.qvm" goto error

if not exist "%GAME_DIR%\BigMod\vm" (
	mkdir "%GAME_DIR%\BigMod\vm"
)

copy /Y ^
	"%ROOT%code\cgame\vm\cgame.qvm" ^
	"%GAME_DIR%\BigMod\vm\cgame.qvm"

if errorlevel 1 goto error

echo CGAME QVM BUILT AND COPIED
pause
exit /b 0

:error
echo CGAME BUILD FAILED
pause
exit /b 1