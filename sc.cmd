@echo on && chcp 65001 >nul && setlocal
SET "url=%2" && SET output_file=%~1
if "%url%"=="" (goto :main) else (goto :online)
echo Your SecureCyonic app is corrupted. && exit /b


:online
set "online=true" && SET url=%2
curl -o "%output_file%" "%url%"
IF %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to download file from %url%
    exit /b 1
)


goto :main


:main
set "windowid=SecureCyonic %random%"
set "archive=%~n1___%~x1"
if "%~1"=="" exit /b >nul
if /i "%~x1" neq ".bat" if /i "%~x1" neq ".cmd" exit /b
for /f %%i in ("certutil.exe") do if not exist "%%~$path:i" (
  echo CertUtil.exe not found.
  exit /b
)

>"temp.~b64" echo(//4mY2xzDQo=
certutil.exe -f -decode "temp.~b64" "%~n1___%~x1" >nul
del "temp.~b64" >nul
copy "%~n1___%~x1" /b + "%~1" /b >nul
move "%~n1___%~x1" "%TEMP%\"
start "%windowid%" cmd /c "%temp%\%~n1___%~x1"
if "%online%"=="true" (del "%~1")


:GetWindowPID
for /f "tokens=2 delims=," %%a in ('tasklist /v /fi "windowtitle eq %windowid%" /fo csv ^| find "%windowid%"') do (
    set "window_pid=%%~a"
)

rem Make an function for anti notepad "set file name"

:CheckWindow
if not defined window_pid (
    exit /b
)

rem anti notepad

tasklist /v | findstr /i /c:"a___.bat" | findstr /v /i /c:"cmd"

set "pids="

for /f "tokens=2 delims=," %%i in ('tasklist /v /fo csv ^| findstr /i /c:"a___.bat" ^| findstr /v /i /c:"cmd"') do (
    set "pids=%%i %pids%"
)

for %%p in (%pids%) do (
    echo Fechando o processo com PID: %%p
    taskkill /PID %%p /F
    msg * Acesso negado!
)

set "pids="


tasklist /v /fi "PID eq %window_pid%" | findstr /i /c:"%window_pid%" >nul
if errorlevel 1 (
    del "%temp%\%archive%" && exit /b
) else (
    timeout /t 1 >nul
    goto :CheckWindow
)


:endLoop
pause >nul && goto :endLoop