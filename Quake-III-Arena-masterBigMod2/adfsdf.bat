findstr /n /c:"GiveRandomStartWeapon" /c:"void ClientSpawn" code\game\g_client.c
powershell.exe -NoProfile -NonInteractive -Command "Get-Content -LiteralPath 'code\game\g_client.c' | Select-Object -Skip 1235 -First 120"
pause