@echo off
setlocal

rem Переходим в каталог, где находится этот BAT-файл
pushd "%~dp0"

rem Очищаем переменные старых компиляторов
set LIBRARY=
set INCLUDE=

rem Добавляем инструменты компиляции QVM
set "PATH=%~dp0..\win32\mod-sdk-setup\bin;%PATH%"

rem Проверяем инструменты
where lcc >nul 2>nul
if errorlevel 1 (
	echo ERROR: lcc.exe not found
	goto failed
)

where q3asm >nul 2>nul
if errorlevel 1 (
	echo ERROR: q3asm.exe not found
	goto failed
)

if not exist vm mkdir vm
cd vm

set cc=lcc -DQ3_VM -S -Wf-target=bytecode -Wf-g -I..\..\cgame -I..\..\game -I..\..\ui %*

echo Compiling game VM...

%cc% ../g_main.c
if errorlevel 1 goto failed_vm

%cc% ../bg_misc.c
if errorlevel 1 goto failed_vm

%cc% ../bg_monster.c
if errorlevel 1 goto failed_vm

%cc% ../g_monster.c
if errorlevel 1 goto failed_vm

%cc% ../bg_lib.c
if errorlevel 1 goto failed_vm

%cc% ../bg_pmove.c
if errorlevel 1 goto failed_vm

%cc% ../bg_slidemove.c
if errorlevel 1 goto failed_vm

%cc% ../q_math.c
if errorlevel 1 goto failed_vm

%cc% ../q_shared.c
if errorlevel 1 goto failed_vm

rem Bot AI
%cc% ../ai_dmnet.c
if errorlevel 1 goto failed_vm

%cc% ../ai_dmq3.c
if errorlevel 1 goto failed_vm

%cc% ../ai_assault.c
if errorlevel 1 goto failed_vm

%cc% ../ai_main.c
if errorlevel 1 goto failed_vm

%cc% ../ai_chat.c
if errorlevel 1 goto failed_vm

%cc% ../ai_cmd.c
if errorlevel 1 goto failed_vm

%cc% ../ai_team.c
if errorlevel 1 goto failed_vm

%cc% ../ai_vcmd.c
if errorlevel 1 goto failed_vm

rem Game logic
%cc% ../g_active.c
if errorlevel 1 goto failed_vm

%cc% ../g_arenas.c
if errorlevel 1 goto failed_vm

%cc% ../g_assault.c
if errorlevel 1 goto failed_vm

%cc% ../g_bot.c
if errorlevel 1 goto failed_vm

%cc% ../g_client.c
if errorlevel 1 goto failed_vm

%cc% ../g_cmds.c
if errorlevel 1 goto failed_vm

%cc% ../g_combat.c
if errorlevel 1 goto failed_vm

%cc% ../g_items.c
if errorlevel 1 goto failed_vm

%cc% ../g_mem.c
if errorlevel 1 goto failed_vm

%cc% ../g_misc.c
if errorlevel 1 goto failed_vm

%cc% ../g_missile.c
if errorlevel 1 goto failed_vm

%cc% ../g_mover.c
if errorlevel 1 goto failed_vm

%cc% ../g_session.c
if errorlevel 1 goto failed_vm

%cc% ../g_spawn.c
if errorlevel 1 goto failed_vm

%cc% ../g_svcmds.c
if errorlevel 1 goto failed_vm

%cc% ../g_target.c
if errorlevel 1 goto failed_vm

%cc% ../g_team.c
if errorlevel 1 goto failed_vm

%cc% ../g_trigger.c
if errorlevel 1 goto failed_vm

%cc% ../g_utils.c
if errorlevel 1 goto failed_vm

%cc% ../g_weapon.c
if errorlevel 1 goto failed_vm

echo Linking qagame.qvm...

if exist qagame.qvm del /Q qagame.qvm
q3asm -f ../game
if errorlevel 1 goto failed_vm
if not exist qagame.qvm goto failed_vm


echo.
echo ========================================
echo BUILD SUCCESSFUL
echo Result: code\game\vm\qagame.qvm
echo ========================================
echo.

cd ..
popd
endlocal
pause
exit /b 0

:failed_vm
echo.
echo ========================================
echo BUILD FAILED
echo Check the first compiler error above.
echo ========================================
echo.
cd ..
popd
endlocal
pause
exit /b 1

:failed
echo.
echo ========================================
echo BUILD FAILED
echo Required QVM tools were not found.
echo ========================================
echo.
popd
endlocal
pause
exit /b 1