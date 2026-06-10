@echo off

setlocal



set "DLL_ROOT=%~dp0.."

set "MSBUILD=C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"

set "OUTPUT=%~dp0..\..\Skyrim AE Plugin\Data\SKSE\Plugins"



if not exist "%MSBUILD%" (

    echo Could not find MSBuild. Install Visual Studio 2022 with the C++ desktop workload.

    exit /b 1

)



if not exist "%OUTPUT%" mkdir "%OUTPUT%"



echo Building common_vc14...

"%MSBUILD%" "%DLL_ROOT%\common\common_vc14.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:PlatformToolset=v143 /p:WindowsTargetPlatformVersion=10.0 /m /v:minimal

if errorlevel 1 exit /b 1



echo Building skse64_common...

"%MSBUILD%" "%DLL_ROOT%\skse64\skse64_common\skse64_common.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:PlatformToolset=v143 /p:WindowsTargetPlatformVersion=10.0 /m /v:minimal

if errorlevel 1 exit /b 1



echo Building CrowdControl plugin...

"%MSBUILD%" "%~dp0MyFirstPlugin.vcxproj" /p:Configuration=Release /p:Platform=x64 /p:PlatformToolset=v143 /p:WindowsTargetPlatformVersion=10.0 /m /v:minimal

if errorlevel 1 exit /b 1



copy /Y "%DLL_ROOT%\x64\Release\CrowdControl.dll" "%OUTPUT%\CrowdControl.dll"

echo.

echo Built: %OUTPUT%\CrowdControl.dll

exit /b 0


