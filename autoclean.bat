
@echo off
echo Limpando arquivos de log do sistema
echo.
cd/
del *.log /a /s /q /f
cd C:/ & del *.log /a /s /q /f

REM Parando serviços relacionados ao Windows Update
echo.
echo Parando servicos relacionados ao Windows Update...
echo.
net stop UsoSvc
net stop bits
net stop dosvc

REM Deletando pasta de distribuicao do Windows Update
echo.
echo Deletando Arquivos do Windows Update...
echo.
net stop wuauserv
net stop UsoSvc
rd /s /q C:\Windows\SoftwareDistribution
md C:\Windows\SoftwareDistribution

REM Limpando arquivos temporarios do sistema
echo.
echo Iniciando limpeza do Windows (cleanmgr.exe)...
echo.
start "" /wait "C:\Windows\System32\cleanmgr.exe" /sagerun:50 

echo.
echo Tomando posse e excluindo outras pastas temporarias...
echo.
takeown /f %LocalAppData%\Microsoft\Windows\Explorer\ /r /d y
takeown /f %%G\AppData\Local\Temp\ /r /d y
takeown /f %SystemRoot%\TEMP\ /r /d y
takeown /f %systemdrive%\$Recycle.bin\ /r /d y
takeown /f C:\Users\%USERNAME%\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Code Cache\ /r /d y
takeown /f C:\Users\%USERNAME%\AppData\Local\Fortnitegame\saved\ /r /d y
takeown /f C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\Code Cache\ /r /d y
takeown /f "%temp%" /r /d y
RD /S /Q %temp%
MKDIR %temp%
takeown /f "%temp%" /r /d y
takeown /f "C:\Windows\Temp" /r /d y
RD /S /Q C:\Windows\Temp
MKDIR C:\Windows\Temp
takeown /f "C:\Windows\Temp" /r /d y

echo.
echo Limpando arquivos temporarios relacionados a Epic Games e Fortnite...
echo.
del /q /s %systemdrive%\$Recycle.bin\*
for /d %%x in (%systemdrive%\$Recycle.bin\*) do @rd /s /q "%%x"
powershell.exe Remove-Item -Path $env:TEMP -Recurse -Force -ErrorAction SilentlyContinue
erase /F /S /Q "%SystemRoot%\TEMP*.*"
for /D %%G in ("%SystemRoot%\TEMP*") do RD /S /Q "%%G"
for /D %%G in ("%SystemDrive%\Users*") do erase /F /S /Q "%%G\AppData\Local\Temp*.*"
for /D %%G in ("%SystemDrive%\Users*") do RD /S /Q "%%G\AppData\Local\Temp\" 

echo.
echo Limpeza concluida.
echo.

cls
del %0
exit