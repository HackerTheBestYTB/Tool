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
title Error
cls
color 4f
echo --------------------------------------------------------------------------------------------------
echo                     			Error
echo --------------------------------------------------------------------------------------------------
echo 				Invalid Number
pause
goto CM

:CMERROR1
title Error
cls
color 4f
echo --------------------------------------------------------------------------------------------------
echo                     			Error
echo --------------------------------------------------------------------------------------------------
echo 				Can't Find Roblox. Please Install Roblox
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
echo     	     #     #              Roblox Fps Unlocker Has Been Enabled (FPS:%rbxfps%)
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
echo     	     #     #              Roblox Fps Unlocker Has Been Disabled (FPS:60)
echo      	      #  #
echo       	       #
echo.
echo.
echo --------------------------------------------------------------------------------------------------
pause
goto CM

:CM
title Roblox Fps Unlocker
color 2
cls
echo --------------------------------------------------------------------------------------------------
echo                       			Choose Mode
echo --------------------------------------------------------------------------------------------------
echo.
echo				[1] Enable (Custom Number)
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

:M11
@echo off
set "rootPath=C:\Program Files (x86)\Roblox\Versions"
for /d /r "%rootPath%" %%G in (version-*) do (
    set "versionFolder=%%G"
    goto CreateJsonFile1
)
goto CMERROR1
:CreateJsonFile1
if not exist "%versionFolder%\ClientSettings" (
    mkdir "%versionFolder%\ClientSettings"
)

echo ^{ "DFIntTaskSchedulerTargetFps": %rbxfps% ^} > "%versionFolder%\ClientSettings\ClientAppSettings.json"
goto DONE1

:M1
cls
set/p "rbxfps=Input Number: "
echo.
IF "%rbxfps%"== goto CMERROR
IF %rbxfps% GEQ 1 goto M11
goto CMERROR
goto DONE1

:M2
set "rootPath=C:\Program Files (x86)\Roblox\Versions"

REM Tìm thư mục "version-" với dạng tên không rõ
for /d /r "%rootPath%" %%G in (version-*) do (
    REM Kiểm tra xem thư mục "ClientSettings" tồn tại trong thư mục "version-"
    if exist "%%G\ClientSettings" (
        REM Xóa thư mục "ClientSettings"
        rmdir /s /q "%%G\ClientSettings"
        echo Đã xóa thư mục "ClientSettings" trong thư mục "%%~nxG"
    )
)
goto DONE2

:M3
exit
