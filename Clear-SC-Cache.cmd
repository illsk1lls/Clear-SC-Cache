@ECHO OFF&SET "gameFolder=C:\Program Files\Roberts Space Industries\StarCitizen"&SET "TitleName=Clear SC Cache"
TASKLIST /V /NH /FI "imagename eq cmd.exe"|FIND /I /C "%TitleName%">nul
IF NOT %errorlevel%==1 (ECHO ERROR: & ECHO Clear SC Cache is already open!) |MSG * & GOTO :EOF
TITLE %TitleName%
IF NOT EXIST "%gameFolder%\*" (ECHO Game files not found! Edit the script and put the correct gameFolder path on the first line ;^)&ECHO.&PAUSE&EXIT) ELSE (SET "logFile=%~dp0Clear-SC-Cache.log")
::This section triggers a request to run as Admin
>nul 2>&1 REG ADD HKCU\Software\classes\.ScCleanup\shell\runas\command /f /ve /d "CMD /x /d /r SET \"f0=%%2\"& CALL \"%%2\" %%3"
>nul 2>&1 FLTMC|| IF "%f0%" NEQ "%~f0" (cd.>"%temp%\runas.ScCleanup" & START "%~n0" /high "%temp%\runas.ScCleanup" "%~f0"&EXIT /b)
::It halts here if not granted
>nul 2>&1 REG DELETE HKCU\Software\classes\.ScCleanup\ /f&>nul 2>&1 DEL %temp%\runas.ScCleanup /f /q
TASKLIST /V /NH /FI "imagename eq starcitizen.exe"|FIND /I /C "Star Citizen">nul
IF NOT %errorlevel%==1 (ECHO THE GAME IS RUNNING: & ECHO Close the game and run the tool again.) |MSG * & GOTO :EOF
CD.>%logFile%&ECHO Clearing Star Citizen Shader Cache...^(Keybindings are preserved^)&ECHO.
IF EXIST "%localAppData%\Star Citizen\*" (
>nul 2>&1 RD /S /Q "%localAppData%\Star Citizen"&&(ECHO Game shader folder successfully cleared...>>"%logFile%"&ECHO.>>"%logFile%")||(ECHO Error clearing game shader folder...>>"%logFile%"&ECHO.>>"%logFile%")
) ELSE (ECHO Game shader folder already clear...>>"%logFile%"&ECHO.>>"%logFile%" )
FOR /f "usebackq skip=7 tokens=5" %%# in (`DIR "%gameFolder%" /A:D`) DO (IF NOT "%%#"=="free" CALL :SAFECLEARUSER "%gameFolder%\%%#\USER\Client\0" "%%#")
CHOICE /C YN /N /M "Would you like to clear the system shader folders as well [nVidia/AMD] (Y/N)?"
IF %errorlevel%==1 CALL :SAFECLEARSYSTEM
ECHO.&ECHO DONE.&ECHO.&PAUSE&GOTO :EOF
:SAFECLEARUSER
IF EXIST "%~1\AutoPerfCaptures\*" (
>nul 2>&1 RD /S /Q "%~1\AutoPerfCaptures"&&(ECHO %~2 User folder part 1 of 4 successfully cleared...>>"%logFile%")||(ECHO Error clearing %~2 user folder part 1 of 4...>>"%logFile%")
) ELSE (ECHO %~2 User folder part 1 of 4 already clear...>>"%logFile%")
IF EXIST "%~1\DebugGUI\*" (
>nul 2>&1 RD /S /Q "%~1\DebugGUI"&&(ECHO %~2 User folder part 2 of 4 successfully cleared...>>"%logFile%")||(ECHO Error clearing %~2 user folder part 2 of 4...>>"%logFile%")
) ELSE (ECHO %~2 User folder part 2 of 4 already clear...>>"%logFile%")
IF EXIST "%~1\frontend\*" (
>nul 2>&1 RD /S /Q "%~1\frontend"&&(ECHO %~2 User folder part 3 of 4 successfully cleared...>>"%logFile%")||(ECHO Error clearing %~2 user folder part 3 of 4...>>"%logFile%")
) ELSE (ECHO %~2 User folder part 3 of 4 already clear...>>"%logFile%")
IF EXIST "%~1\Profiles\*.xml" (
>nul 2>&1 DEL "%~1\Profiles\*.xml" /F /Q&&(ECHO %~2 User folder part 4 of 4 successfully cleared...>>"%logFile%")||(ECHO Error clearing %~2 user folder part 4 of 4...>>"%logFile%")
) ELSE (ECHO %~2 User folder part 4 of 4 already clear...>>"%logFile%")
TYPE "%logFile%"& >nul 2>&1 DEL /F /Q "%logFile%"&ECHO.
EXIT /b
:SAFECLEARSYSTEM
IF EXIST "%localAppData%\AMD\Dxcache\*" >nul 2>&1 RD /S /Q "%localAppData%\AMD\Dxcache"&&(ECHO AMD DX11 system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing AMD DX11 system shader folder...>>"%logFile%")
IF EXIST "%localAppData%\AMD\DxcCache\*" >nul 2>&1 RD /S /Q "%localAppData%\AMD\DxcCache"&&(ECHO AMD DX12 system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing AMD DX12 system shader folder...>>"%logFile%")
IF EXIST "%localAppData%\AMD\VkCache\*" >nul 2>&1 RD /S /Q "%localAppData%\AMD\VkCache"&&(ECHO AMD Vulkan system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing AMD Vulkan system shader folder...>>"%logFile%")
IF EXIST "%localAppData%\NVIDIA\DXCache\*" >nul 2>&1 RD /S /Q "%localAppData%\NVIDIA\DXCache"&&(ECHO nVidia DX11/12 system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing nVidia DX11/12 system shader folder...>>"%logFile%")
IF EXIST "%localAppData%\NVIDIA\GLCache\*" >nul 2>&1 RD /S /Q "%localAppData%\NVIDIA\GLCache"&&(ECHO nVidia Vulkan system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing nVidia Vulkan system shader folder...>>"%logFile%")
ECHO.&TYPE "%logFile%"& >nul 2>&1 DEL /F /Q "%logFile%"
EXIT /b