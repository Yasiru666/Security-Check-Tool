@echo off
title Security Check Tool
color D
set outputFile=SecurityCheckResults.txt

:menu
cls
call :art
call :center "#####################################"
call :center "*****   Security Check Tool   *****"
call :center "#####################################"
call :center "+++++++++++++++++++++++++++++++++++++"
call :center " 1. Check for unusual user accounts"
call :center " 2. Check for suspicious processes"
call :center " 3. Check for unusual network connections"
call :center " 4. Check for recently modified files"
call :center " 5. Check for suspicious scheduled tasks"
call :center " 6. Run all checks"
call :center " 7. Save all details as txt"
call :center " 8. Exit"
call :center "+++++++++++++++++++++++++++++++++++++"
echo.
set /p choice="Enter your choice: "

if "%choice%"=="1" goto check_accounts
if "%choice%"=="2" goto check_processes
if "%choice%"=="3" goto check_network
if "%choice%"=="4" goto check_files
if "%choice%"=="5" goto check_tasks
if "%choice%"=="6" goto run_all
if "%choice%"=="7" goto save_all
if "%choice%"=="8" goto exit
goto menu

:check_accounts
cls
echo Checking for unusual user accounts...
powershell -command "Get-LocalUser | Where-Object { $_.Enabled -eq $true -and $_.Name -notmatch '^(Administrator|Guest|WDAGUtilityAccount|defaultuser100000|DefaultAccount)$' } | Format-Table -AutoSize Name, Description, Enabled, LastLogon"
echo.
pause
goto menu

:check_processes
cls
echo Checking for suspicious processes...
powershell -command "Get-Process | Where-Object { $_.Name -match 'cmd|powershell|wscript|cscript|taskmgr|regedit' } | Format-Table -AutoSize Id, Name, StartTime"
echo.
pause
goto menu

:check_network
cls
echo Checking for unusual network connections...
powershell -command "Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' -and $_.RemoteAddress -ne '127.0.0.1' -and $_.RemoteAddress -ne '::1' } | Format-Table -AutoSize LocalAddress, LocalPort, RemoteAddress, RemotePort, State"
echo.
pause
goto menu

:check_files
cls
echo Checking for recently modified files in system directories...
powershell -command "$directories = @('C:\Windows\System32', 'C:\Windows\SysWOW64'); $now = Get-Date; $directories | ForEach-Object { Get-ChildItem -Path $_ -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $now.AddDays(-7) } } | Format-Table -AutoSize FullName, LastWriteTime"
echo.
pause
goto menu

:check_tasks
cls
echo Checking for suspicious scheduled tasks...
powershell -command "Get-ScheduledTask | Where-Object { $_.State -eq 'Ready' -or $_.State -eq 'Running' } | Where-Object { $_.TaskName -match 'cmd|powershell|wscript|cscript|taskmgr|regedit' } | Format-Table -AutoSize TaskName, TaskPath, State"
echo.
pause
goto menu

:run_all
cls
echo Running all checks...
echo Checking for unusual user accounts...
powershell -command "Get-LocalUser | Where-Object { $_.Enabled -eq $true -and $_.Name -notmatch '^(Administrator|Guest|WDAGUtilityAccount|defaultuser100000|DefaultAccount)$' } | Format-Table -AutoSize Name, Description, Enabled, LastLogon"
echo.
echo Checking for suspicious processes...
powershell -command "Get-Process | Where-Object { $_.Name -match 'cmd|powershell|wscript|cscript|taskmgr|regedit' } | Format-Table -AutoSize Id, Name, StartTime"
echo.
echo Checking for unusual network connections...
powershell -command "Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' -and $_.RemoteAddress -ne '127.0.0.1' -and $_.RemoteAddress -ne '::1' } | Format-Table -AutoSize LocalAddress, LocalPort, RemoteAddress, RemotePort, State"
echo.
echo Checking for recently modified files in system directories...
powershell -command "$directories = @('C:\Windows\System32', 'C:\Windows\SysWOW64'); $now = Get-Date; $directories | ForEach-Object { Get-ChildItem -Path $_ -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $now.AddDays(-7) } } | Format-Table -AutoSize FullName, LastWriteTime"
echo.
echo Checking for suspicious scheduled tasks...
powershell -command "Get-ScheduledTask | Where-Object { $_.State -eq 'Ready' -or $_.State -eq 'Running' } | Where-Object { $_.TaskName -match 'cmd|powershell|wscript|cscript|taskmgr|regedit' } | Format-Table -AutoSize TaskName, TaskPath, State"
echo.
echo All checks completed.
pause
goto menu

:save_all
cls
echo Saving all details to %outputFile%...
(
    echo Checking for unusual user accounts...
    powershell -command "Get-LocalUser | Where-Object { $_.Enabled -eq $true -and $_.Name -notmatch '^(Administrator|Guest|WDAGUtilityAccount|defaultuser100000|DefaultAccount)$' } | Format-Table -AutoSize Name, Description, Enabled, LastLogon"
    echo.
    echo Checking for suspicious processes...
    powershell -command "Get-Process | Where-Object { $_.Name -match 'cmd|powershell|wscript|cscript|taskmgr|regedit' } | Format-Table -AutoSize Id, Name, StartTime"
    echo.
    echo Checking for unusual network connections...
    powershell -command "Get-NetTCPConnection | Where-Object { $_.State -eq 'Established' -and $_.RemoteAddress -ne '127.0.0.1' -and $_.RemoteAddress -ne '::1' } | Format-Table -AutoSize LocalAddress, LocalPort, RemoteAddress, RemotePort, State"
    echo.
    echo Checking for recently modified files in system directories...
    powershell -command "$directories = @('C:\Windows\System32', 'C:\Windows\SysWOW64'); $now = Get-Date; $directories | ForEach-Object { Get-ChildItem -Path $_ -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.LastWriteTime -ge $now.AddDays(-7) } } | Format-Table -AutoSize FullName, LastWriteTime"
    echo.
    echo Checking for suspicious scheduled tasks...
    powershell -command "Get-ScheduledTask | Where-Object { $_.State -eq 'Ready' -or $_.State -eq 'Running' } | Where-Object { $_.TaskName -match 'cmd|powershell|wscript|cscript|taskmgr|regedit' } | Format-Table -AutoSize TaskName, TaskPath, State"
    echo.
) > %outputFile%
echo All details saved to %outputFile%.
pause
goto menu

:exit
cls
call :center "#####################################"
call :center "          Exiting the tool..."
call :center "#####################################"
pause
exit

:center
setlocal
set "str=%~1"
set "len=50"
set /a spaces=(len-1)/2
set "padding="
for /l %%A in (1,1,%spaces%) do call set "padding= %%padding%%"
echo %padding%%str%
endlocal
goto :EOF


:art
@echo off
color D
cls

echo                  _________-----_____
echo        ____------           __      ----_
echo  ___----             ___------              \
echo     ----________        ----                 \
echo                -----__    ^|             _____)
echo                     __-                /     \
echo         _______-----    ___--          \    /)\
echo   ------_______      ---____            \__/  /
echo                -----__    \ --    _          /\
echo                       --__--__     \_____/   \_/\
echo                               ---^|   /          ^|
echo                                  ^| ^|___________^|
echo                                  ^| ^| ((_(_)^| )_)
echo                                  ^|  \_((_(_)^|/(_)
echo                                   \             (
echo                                    \_____________)

echo _REAL EYES, REALIZE, REAL LIES_!
echo **Created by Yasiru Bhashana...



