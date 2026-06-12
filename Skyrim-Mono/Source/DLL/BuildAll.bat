@echo off
setlocal

set "DLL_ROOT=%~dp0"
set "PLUGIN_DIR=%DLL_ROOT%plugin"
set "MSBUILD=C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"

if not exist "%MSBUILD%" (
    echo Could not find MSBuild. Install Visual Studio 2022 with the C++ desktop workload.
    exit /b 1
)

if not exist "%DLL_ROOT%common" (
    echo SKSE source not linked. Run SetupSkseLinks.bat first.
    exit /b 1
)

set "MSBUILD_ARGS=/p:Platform=x64 /p:PlatformToolset=v143 /p:WindowsTargetPlatformVersion=10.0 /m /v:minimal"

echo Building common_vc14...
"%MSBUILD%" "%DLL_ROOT%common\common_vc14.vcxproj" /p:Configuration=Release %MSBUILD_ARGS%
if errorlevel 1 exit /b 1

echo Building skse64_common (SKSE64)...
"%MSBUILD%" "%DLL_ROOT%skse64_common\skse64_common.vcxproj" /p:Configuration=Release %MSBUILD_ARGS%
if errorlevel 1 exit /b 1

echo Building CrowdControl plugin - Steam 1.6.1170...
"%MSBUILD%" "%PLUGIN_DIR%\CrowdControlPlugin.vcxproj" /p:Configuration=Release_Steam1170 %MSBUILD_ARGS%
if errorlevel 1 exit /b 1

echo Building CrowdControl plugin - GOG 1.6.1179...
"%MSBUILD%" "%PLUGIN_DIR%\CrowdControlPlugin.vcxproj" /p:Configuration=Release_GOG1179 %MSBUILD_ARGS%
if errorlevel 1 exit /b 1

echo Building CrowdControl plugin - Old 1.6.640...
"%MSBUILD%" "%PLUGIN_DIR%\CrowdControlPlugin.vcxproj" /p:Configuration=Release_Old640 %MSBUILD_ARGS%
if errorlevel 1 exit /b 1

if exist "%DLL_ROOT%sksevr\skse64_common\skse64_common.vcxproj" goto BuildVR
echo Skipping VR build - full sksevr SDK not linked.
goto CompilePapyrus

:BuildVR
echo Building skse64_common (SKSEVR)...
"%MSBUILD%" "%DLL_ROOT%sksevr\skse64_common\skse64_common.vcxproj" /p:Configuration=Release %MSBUILD_ARGS%
if errorlevel 1 exit /b 1

echo Building CrowdControl plugin - VR...
"%MSBUILD%" "%PLUGIN_DIR%\CrowdControlPluginVR.vcxproj" /p:Configuration=Release %MSBUILD_ARGS%
if errorlevel 1 exit /b 1

:CompilePapyrus
call "%DLL_ROOT%..\CompileCrowdControl.bat"
exit /b %ERRORLEVEL%
