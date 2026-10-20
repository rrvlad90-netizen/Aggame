@echo off
setlocal

set "ROOT=%~dp0"
set "PATH=%ROOT%code\win32\mod-sdk-setup\bin;%PATH%"

cd /d "%ROOT%code\game"
call game.bat

if errorlevel 1 (
    echo QAGAME BUILD FAILED
    pause
    exit /b 1
)

echo QAGAME BUILD SUCCESS
pause