@echo off
setlocal EnableDelayedExpansion

REM Links SKSE source trees into Source\DLL via directory junctions.
REM Set these to your local SKSE source roots before running.

set "DLL_ROOT=%~dp0"
set "MONO_ROOT=%DLL_ROOT%..\..\"
if not defined SKSE64_SRC (
    if exist "i:\AllCrowdControl-Packs\CCPack-PC-SkyrimAEGOG\Source\DLL\common" (
        set "SKSE64_SRC=i:\AllCrowdControl-Packs\CCPack-PC-SkyrimAEGOG\Source\DLL"
    ) else (
        echo Set SKSE64_SRC to a folder containing common, skse64, skse64_common, loaders, sheets.
        exit /b 1
    )
)

if not defined SKSEVR_SRC (
    if exist "i:\AllCrowdControl-Packs\CCPack-PC-SkyrimVR\Source\DLL\sksevr" (
        set "SKSEVR_SRC=i:\AllCrowdControl-Packs\CCPack-PC-SkyrimVR\Source\DLL"
    ) else (
        echo Set SKSEVR_SRC to the folder that contains the sksevr directory.
        exit /b 1
    )
)

call :LinkDir "%SKSE64_SRC%\common" "%DLL_ROOT%common"
call :LinkDir "%SKSE64_SRC%\skse64" "%DLL_ROOT%skse64"
call :LinkDir "%SKSE64_SRC%\skse64_common" "%DLL_ROOT%skse64_common"
call :LinkDir "%SKSE64_SRC%\skse64_loader" "%DLL_ROOT%skse64_loader"
call :LinkDir "%SKSE64_SRC%\skse64_loader_common" "%DLL_ROOT%skse64_loader_common"
call :LinkDir "%SKSE64_SRC%\skse64_steam_loader" "%DLL_ROOT%skse64_steam_loader"
if exist "%SKSE64_SRC%\sheets" call :LinkDir "%SKSE64_SRC%\sheets" "%DLL_ROOT%sheets"
call :LinkDir "%SKSEVR_SRC%\sksevr" "%DLL_ROOT%sksevr"

echo.
echo SKSE junctions are ready under %DLL_ROOT%
exit /b 0

:LinkDir
set "SRC=%~1"
set "DEST=%~2"
if not exist "%SRC%" (
    echo Missing source: %SRC%
    exit /b 1
)
if exist "%DEST%" (
    echo Exists: %DEST%
) else (
    mklink /J "%DEST%" "%SRC%"
    echo Linked: %DEST%
)
exit /b 0
