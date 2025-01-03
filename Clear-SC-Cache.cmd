@ECHO OFF&SET "gameFolder=C:\Program Files\Roberts Space Industries\StarCitizen"&SET "TitleName=Clear SC Cache"
REM If the script is already running a notification bell and message box will alert you, then the new instance will exit
TASKLIST /V /NH /FI "imagename eq cmd.exe"|FIND /I /C "%TitleName%">nul
IF NOT %errorlevel%==1 POWERSHELL -nop -c "$^={$Notify=[PowerShell]::Create().AddScript({$Audio=New-Object System.Media.SoundPlayer;$Audio.SoundLocation=$env:WinDir + '\Media\Windows Notify System Generic.wav';$Audio.playsync()});$rs=[RunspaceFactory]::CreateRunspace();$rs.ApartmentState="^""STA"^"";$rs.ThreadOptions="^""ReuseThread"^"";$rs.Open();$Notify.Runspace=$rs;$Notify.BeginInvoke()};&$^;$PopUp=New-Object -ComObject Wscript.Shell;$PopUp.Popup("^""Clear SC Cache is already open!"^"",0,'ERROR:',0x10)">nul&EXIT
TITLE %TitleName%
IF NOT EXIST "%gameFolder%\*" (ECHO Game files not found! Edit the script and put the correct gameFolder path on the first line ;^)&ECHO/&PAUSE&EXIT) ELSE (SET logFile="%~dp0Clear-SC-Cache.log")
REM This section triggers a request to run as Admin
>nul 2>&1 REG ADD HKCU\Software\classes\.ScCleanup\shell\runas\command /f /ve /d "CMD /x /d /r SET \"f0=%%2\"& CALL \"%%2\" %%3"
>nul 2>&1 FLTMC|| IF "%f0%" NEQ "%~f0" (cd.>"%temp%\runas.ScCleanup" & START "%~n0" /high "%temp%\runas.ScCleanup" "%~f0"&EXIT /b)
REM It halts here if not granted
>nul 2>&1 REG DELETE HKCU\Software\classes\.ScCleanup\ /f&>nul 2>&1 DEL %temp%\runas.ScCleanup /f /q
TASKLIST /V /NH /FI "imagename eq starcitizen.exe"|FIND /I /C "Star Citizen">nul
IF NOT %errorlevel%==1 (ECHO THE GAME IS RUNNING: & ECHO Close the game and run the tool again.) |MSG * & GOTO :EOF
CD.>%logFile%&ECHO Clearing Star Citizen Shader Cache...^(Keybindings are preserved^)&ECHO/
IF EXIST "%localAppData%\Star Citizen\*" (
>nul 2>&1 RD /S /Q "%localAppData%\Star Citizen"&&(ECHO Game shader folder successfully cleared...>>%logFile%&ECHO/>>%logFile%)||(ECHO Error clearing game shader folder...>>%logFile%&ECHO/>>%logFile%)
) ELSE (ECHO Game shader folder already clear...>>%logFile%&ECHO/>>%logFile% )
FOR /f "usebackq skip=7 tokens=5" %%# in (`DIR "%gameFolder%" /A:D`) DO (IF NOT "%%#"=="free" SET /A userNumber=0&CALL :SAFECLEARUSERS "%gameFolder%\%%#\USER\Client\" "%%#")
CHOICE /C YN /N /M "Would you like to clear the system shader folders as well [nVidia/AMD] (Y/N)?"
IF %errorlevel%==1 CALL :SAFECLEARSYSTEM
ECHO/&ECHO DONE.&ECHO/&PAUSE&GOTO :EOF
:SAFECLEARUSERS
IF NOT EXIST "%~1\%userNumber%\*" EXIT /b
IF EXIST "%~1\%userNumber%\AutoPerfCaptures\*" (
>nul 2>&1 RD /S /Q "%~1\%userNumber%\AutoPerfCaptures"&&(ECHO %~2 User #%userNumber% folder part 1 of 4 successfully cleared...>>%logFile%)||(ECHO Error clearing %~2 User #%userNumber% folder part 1 of 4...>>%logFile%)
) ELSE (ECHO %~2 User #%userNumber% folder part 1 of 4 already clear...>>%logFile%)
IF EXIST "%~1\%userNumber%\DebugGUI\*" (
>nul 2>&1 RD /S /Q "%~1\%userNumber%\DebugGUI"&&(ECHO %~2 User #%userNumber% folder part 2 of 4 successfully cleared...>>%logFile%)||(ECHO Error clearing %~2 User #%userNumber% folder part 2 of 4...>>%logFile%)
) ELSE (ECHO %~2 User #%userNumber% folder part 2 of 4 already clear...>>%logFile%)
IF EXIST "%~1\%userNumber%\frontend\*" (
>nul 2>&1 RD /S /Q "%~1\%userNumber%\frontend"&&(ECHO %~2 User #%userNumber% folder part 3 of 4 successfully cleared...>>%logFile%)||(ECHO Error clearing %~2 User #%userNumber% folder part 3 of 4...>>%logFile%)
) ELSE (ECHO %~2 User #%userNumber% folder part 3 of 4 already clear...>>%logFile%)
IF EXIST "%~1\%userNumber%\Profiles\*.xml" (
>nul 2>&1 DEL "%~1\%userNumber%\Profiles\*.xml" /F /Q&&(ECHO %~2 User #%userNumber% folder part 4 of 4 successfully cleared...>>%logFile%)||(ECHO Error clearing %~2 User #%userNumber% folder part 4 of 4...>>%logFile%)
) ELSE (ECHO %~2 User #%userNumber% folder part 4 of 4 already clear...>>%logFile%)
TYPE %logFile%& >nul 2>&1 DEL /F /Q %logFile%&ECHO/
SET /A userNumber+=1
GOTO SAFECLEARUSERS
:SAFECLEARSYSTEM
IF EXIST "%localAppData%\AMD\Dxcache\*" >nul 2>&1 RD /S /Q "%localAppData%\AMD\Dxcache"&&(ECHO AMD DX11 system shader folder successfully cleared...>>%logFile%)||(ECHO Error clearing AMD DX11 system shader folder...>>%logFile%)
IF EXIST "%localAppData%\AMD\DxcCache\*" >nul 2>&1 RD /S /Q "%localAppData%\AMD\DxcCache"&&(ECHO AMD DX12 system shader folder successfully cleared...>>%logFile%)||(ECHO Error clearing AMD DX12 system shader folder...>>%logFile%)
IF EXIST "%localAppData%\AMD\VkCache\*" >nul 2>&1 RD /S /Q "%localAppData%\AMD\VkCache"&&(ECHO AMD Vulkan system shader folder successfully cleared...>>%logFile%)||(ECHO Error clearing AMD Vulkan system shader folder...>>%logFile%)
IF EXIST "%localAppData%\NVIDIA\DXCache\*" >nul 2>&1 RD /S /Q "%localAppData%\NVIDIA\DXCache"&&(ECHO nVidia DX11/12 system shader folder successfully cleared...>>%logFile%)||(ECHO Error clearing nVidia DX11/12 system shader folder...>>%logFile%)
IF EXIST "%localAppData%\NVIDIA\GLCache\*" >nul 2>&1 RD /S /Q "%localAppData%\NVIDIA\GLCache"&&(ECHO nVidia Vulkan system shader folder successfully cleared...>>%logFile%)||(ECHO Error clearing nVidia Vulkan system shader folder...>>%logFile%)
ECHO/&IF EXIST "%logFile%" (TYPE %logFile%) ELSE (ECHO Nothing to clear...) & >nul 2>&1 DEL /F /Q %logFile%
EXIT /b