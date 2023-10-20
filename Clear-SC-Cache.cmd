@ECHO OFF&SET "gameFolder=C:\Program Files\Roberts Space Industries\StarCitizen\LIVE"
IF NOT EXIST "%gameFolder%\*" (ECHO Game files not found! Edit the script and put the correct gameFolder path on the first line ;^)&ECHO.&PAUSE&EXIT) ELSE (SET "userFolder=%gameFolder%\USER\Client\0"&SET "logFile=%~dp0Clear-SC-Cache.log")
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
IF EXIST "%localAppData%\AMD" >nul 2>&1 RD /S /Q "%localAppData%\AMD"&&(ECHO AMD system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing AMD system shader folder...>>"%logFile%")
IF EXIST "%localAppData%\NVIDIA\DXCache" >nul 2>&1 RD /S /Q "%localAppData%\NVIDIA\DXCache"&&(ECHO nVidia system shader folder successfully cleared...>>"%logFile%")||(ECHO Error clearing game shader folder...>>"%logFile%")
ECHO.&TYPE "%logFile%"& >nul 2>&1 DEL /F /Q "%logFile%"
)
ECHO.&ECHO DONE.&ECHO.&PAUSE&GOTO :EOF