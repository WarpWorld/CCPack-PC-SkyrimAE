@echo off
setlocal

if not defined SKYRIM_SE (
    set "SKYRIM_SE=D:\SteamLibrary\steamapps\common\Skyrim Special Edition"
)

set "COMPILER=%SKYRIM_SE%\Papyrus Compiler\PapyrusCompiler.exe"
set "FLAGS=%SKYRIM_SE%\Data\Source\Scripts\TESV_Papyrus_Flags.flg"
set "INCLUDES=%SKYRIM_SE%\Data\Scripts\Source;%SKYRIM_SE%\Data\Source\Scripts"
set "SOURCE=%~dp0CrowdControl.psc"
set "MONO_ROOT=%~dp0..\"
set "PLUGIN_ROOT=%MONO_ROOT%Plugins\"

if not exist "%COMPILER%" (
    echo Could not find PapyrusCompiler.exe at:
    echo   %COMPILER%
    echo Set SKYRIM_SE to your Skyrim Special Edition install path and rerun.
    exit /b 1
)

set "TEMP_OUT=%TEMP%\SkyrimMonoPapyrus"
if not exist "%TEMP_OUT%" mkdir "%TEMP_OUT%"

pushd "%SKYRIM_SE%\Papyrus Compiler"
copy /Y "%SOURCE%" "CrowdControl.psc" >nul
"%COMPILER%" "CrowdControl.psc" "-f=%FLAGS%" "-i=%INCLUDES%" "-o=%TEMP_OUT%"
set "RESULT=%ERRORLEVEL%"
popd

if not "%RESULT%"=="0" (
    echo Compilation failed with exit code %RESULT%.
    exit /b %RESULT%
)

call :DeployPex "Skyrim AE Plugin"
call :DeployPex "Skyrim AE GOG Plugin"
call :DeployPex "Skyrim AE Old Plugin"
call :DeployPex "Skyrim VR Plugin"

if exist "%SKYRIM_SE%\Data\Scripts" (
    copy /Y "%TEMP_OUT%\CrowdControl.pex" "%SKYRIM_SE%\Data\Scripts\CrowdControl.pex" >nul
    echo Deployed: %SKYRIM_SE%\Data\Scripts\CrowdControl.pex
)

exit /b 0

:DeployPex
set "DEST=%PLUGIN_ROOT%%~1\Data\Scripts"
if not exist "%DEST%" mkdir "%DEST%"
copy /Y "%TEMP_OUT%\CrowdControl.pex" "%DEST%\CrowdControl.pex" >nul
echo Built: %DEST%\CrowdControl.pex
exit /b 0
