@echo off
setlocal

pushd "%~dp0"

set LIBRARY=
set INCLUDE=
set "PATH=%~dp0..\win32\mod-sdk-setup\bin;%PATH%"

where lcc >nul 2>nul
if errorlevel 1 goto failed

where q3asm >nul 2>nul
if errorlevel 1 goto failed

if not exist vm mkdir vm
cd vm

set cc=lcc -DQ3_VM -DMISSIONPACK -S -Wf-target=bytecode -Wf-g -I..\..\cgame -I..\..\game -I..\..\ui %*

%cc% ../g_main.c
if errorlevel 1 goto failed_vm
%cc% ../g_syscalls.c
if errorlevel 1 goto failed_vm

%cc% ../bg_misc.c
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

q3asm -f ../game_ta
if errorlevel 1 goto failed_vm

echo.
echo Team Arena game VM built successfully.
echo.
cd ..
popd
endlocal
pause
exit /b 0

:failed_vm
echo.
echo Team Arena build failed.
echo Check the first error above.
echo.
cd ..
popd
endlocal
pause
exit /b 1

:failed
echo.
echo lcc.exe or q3asm.exe not found.
echo.
popd
endlocal
pause
exit /b 1