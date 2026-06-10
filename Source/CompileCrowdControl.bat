@echo off
setlocal

if not defined SKYRIM_SE (
    set "SKYRIM_SE=D:\SteamLibrary\steamapps\common\Skyrim Special Edition"
)

set "COMPILER=%SKYRIM_SE%\Papyrus Compiler\PapyrusCompiler.exe"
set "FLAGS=%SKYRIM_SE%\Data\Source\Scripts\TESV_Papyrus_Flags.flg"
set "INCLUDES=%SKYRIM_SE%\Data\Scripts\Source;%SKYRIM_SE%\Data\Source\Scripts"
set "SOURCE=%~dp0CrowdControl.psc"
set "OUTPUT=%~dp0..\Skyrim AE Plugin\Data\Scripts"

if not exist "%COMPILER%" (
    echo Could not find PapyrusCompiler.exe at:
    echo   %COMPILER%
    echo Set SKYRIM_SE to your Skyrim Special Edition install path and rerun.
    exit /b 1
)

pushd "%SKYRIM_SE%\Papyrus Compiler"
copy /Y "%SOURCE%" "CrowdControl.psc" >nul
"%COMPILER%" "CrowdControl.psc" "-f=%FLAGS%" "-i=%INCLUDES%" "-o=%OUTPUT%"
set "RESULT=%ERRORLEVEL%"
popd

if not "%RESULT%"=="0" (
    echo Compilation failed with exit code %RESULT%.
    exit /b %RESULT%
)

echo.
echo Built: %OUTPUT%\CrowdControl.pex
exit /b 0
