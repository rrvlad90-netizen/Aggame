@echo off
lovr.exe --console Autobattler3D > crashlog.txt 2>&1
echo Exit code: %errorlevel%
type crashlog.txt
pause