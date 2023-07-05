@echo off
color 2
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:-------------------------------------
cls
goto CM

:CMERROR
title Login Choose Mode Error
cls
color 4f
echo --------------------------------------------------------------------------------------------------
echo                     			Error
echo --------------------------------------------------------------------------------------------------
echo 				Invalid Number
pause
goto CM

:DONE1
title Done
cls
color 0a
echo --------------------------------------------------------------------------------------------------
echo                       			Done
echo --------------------------------------------------------------------------------------------------
echo.
echo               	       #
echo             	     #
echo     	     #     #              Windows Update Has Been Enabled
echo      	      #  #
echo       	       #
echo.
echo.
echo --------------------------------------------------------------------------------------------------
pause
goto CM

:DONE2
title Done
cls
color 0a
echo --------------------------------------------------------------------------------------------------
echo                       			Done
echo --------------------------------------------------------------------------------------------------
echo.
echo               	       #
echo             	     #
echo     	     #     #              Windows Update Has Been Disabled
echo      	      #  #
echo       	       #
echo.
echo.
echo --------------------------------------------------------------------------------------------------
pause
goto CM

:CM
title Windows Update Controller
color 2
cls
echo --------------------------------------------------------------------------------------------------
echo                       			Choose Mode
echo --------------------------------------------------------------------------------------------------
echo.
echo				[1] Enable
echo    			[2] Disable
echo    			[3] Exit
echo.
echo --------------------------------------------------------------------------------------------------
echo.
set/p "mode=_               	Mode: "
echo.
IF "%mode%"== goto CMERROR
IF %mode%==1 goto M1
IF %mode%==2 goto M2
IF %mode%==3 goto M3
goto CMERROR

:M1
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d 4 /f
sc config wuauserv start= demand
sc start wuauserv
goto DONE1

:M2
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wuauserv" /v "Start" /t REG_DWORD /d 3 /f
sc config wuauserv start= disabled
sc stop wuauserv
goto DONE2

:M3
exit
