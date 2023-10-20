@ECHO OFF&SET "gameFolder=C:\Program Files\Roberts Space Industries\StarCitizen\LIVE"
SET "TitleName=Clear SC Cache"
TASKLIST /V /NH /FI "imagename eq cmd.exe"|FIND /I /C "%TitleName%">nul
IF NOT %errorlevel%==1 (ECHO ERROR: & ECHO Clear SC Cache is already open!) |MSG * & EXIT /b
TITLE %TitleName%
IF NOT EXIST "%gameFolder%\*" (ECHO Game files not found! Edit the script and put the correct gameFolder path on the first line ;^)&ECHO.&PAUSE&EXIT) ELSE (SET "userFolder=%gameFolder%\USER\Client\0"&SET "logFile=%~dp0Clear-SC-Cache.log")
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
IF EXIST "%userFolder%\AutoPerfCaptures\*" (
>nul 2>&1 RD /S /Q "%userFolder%\AutoPerfCaptures"&&(ECHO User folder part 1 of 4 successfully cleared...>>"%logFile%")||(ECHO Error clearing user folder part 1 of 4...>>"%logFile%")
) ELSE (ECHO User folder part 1 of 4 already clear...>>"%logFile%")
IF EXIST "%userFolder%\DebugGUI\*" (
>nul 2>&1 RD /S /Q "%userFolder%\DebugGUI"&&(ECHO User folder part 2 of 4 successfully cleared...>>"%logFile%")||(ECHO Error clearing user folder part 2 of 4...>>"%logFile%")
) ELSE (ECHO User folder part 2 of 4 already clear...>>"%logFile%")
IF EXIST "%userFolder%\frontend\*" (
>nul 2>&1 RD /S /Q "%userFolder%\frontend"&&(ECHO User folder part 3 of 4 successfully cleared...>>"%logFile%")||(ECHO Error clearing user folder part 3 of 4...>>"%logFile%")
) ELSE (ECHO User folder part 3 of 4 already clear...>>"%logFile%")
IF EXIST "%userFolder%\Profiles\*.xml" (
>nul 2>&1 DEL "%userFolder%\Profiles\*.xml" /F /Q&&(ECHO User folder part 4 of 4 successfully cleared...>>"%logFile%")||(ECHO Error clearing user folder part 4 of 4...>>"%logFile%")
) ELSE (ECHO User folder part 4 of 4 already clear...>>"%logFile%")
TYPE "%logFile%"& >nul 2>&1 DEL /F /Q "%logFile%"&ECHO.
CHOICE /C YN /N /M "Would you like to clear the system shader folders as well [nVidia/AMD] (Y/N)?"
IF %errorlevel%==1 (
IF EXIST "%localAppData%\AMD\Dxcache\*" >nul 2>&1 RD /S /Q "%localAppData%\AMD\Dxcache"&&(ECHO AMD DX11 system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing AMD DX11 system shader folder...>>"%logFile%")
IF EXIST "%localAppData%\AMD\DxcCache\*" >nul 2>&1 RD /S /Q "%localAppData%\AMD\DxcCache"&&(ECHO AMD DX12 system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing AMD DX12 system shader folder...>>"%logFile%")
IF EXIST "%localAppData%\AMD\VkCache\*" >nul 2>&1 RD /S /Q "%localAppData%\AMD\VkCache"&&(ECHO AMD Vulkan system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing AMD Vulkan system shader folder...>>"%logFile%")
IF EXIST "%localAppData%\NVIDIA\DXCache\*" >nul 2>&1 RD /S /Q "%localAppData%\NVIDIA\DXCache"&&(ECHO nVidia DX11/12 system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing nVidia DX11/12 system shader folder...>>"%logFile%")
IF EXIST "%localAppData%\NVIDIA\GLCache\*" >nul 2>&1 RD /S /Q "%localAppData%\NVIDIA\GLCache"&&(ECHO nVidia Vulkan system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing nVidia Vulkan system shader folder...>>"%logFile%")
ECHO.&TYPE "%logFile%"& >nul 2>&1 DEL /F /Q "%logFile%"
)
ECHO.&ECHO DONE.&ECHO.&PAUSE&GOTO :EOF