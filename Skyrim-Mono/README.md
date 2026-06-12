# Skyrim-Mono

Unified Crowd Control pack for Skyrim Special Edition (Steam, GOG, legacy runtime) and Skyrim VR.

One shared Papyrus script, one native plugin source tree, and four Crowd Control pack entry points. Each game variant still gets its own `CrowdControl.dll` build because SKSE runtime IDs differ.

## Layout

```
Skyrim-Mono/
  SkyrimAE.cs / SkyrimAEGOG.cs / SkyrimAEOld.cs / SkyrimVR.cs   # CC app pack IDs
  SkyrimEffects.cs / SkyrimPackBase.cs                          # shared effect list
  Source/
    CrowdControl.psc
    CompileCrowdControl.bat
    DLL/
      SetupSkseLinks.bat      # junction SKSE source into Source/DLL
      BuildAll.bat            # build all plugin variants + Papyrus
      configs/                # per-target MSBuild settings
      plugin/                 # shared C++ plugin (Connector, GameState, …)
  Plugins/
    Skyrim AE Plugin/         # Steam AE 1.6.1170
    Skyrim AE GOG Plugin/     # GOG 1.6.1179
    Skyrim AE Old Plugin/     # legacy 1.6.640
    Skyrim VR Plugin/         # Skyrim VR / SKSEVR
```

## Prerequisites

- Visual Studio 2022 with C++ desktop workload (MSBuild `v143`)
- Skyrim Special Edition install (for Papyrus compiler), or set `SKYRIM_SE`
- SKSE64 source tree (default: junctions from `CCPack-PC-SkyrimAEGOG`) — used for all four `CrowdControl.dll` builds, including VR
- SKSEVR 2.0.12 binaries for packaging (`sksevr_loader.exe`, etc.) from [skse.silverlock.org](https://skse.silverlock.org/) or your existing VR pack

## Build

```bat
cd Source\DLL
SetupSkseLinks.bat
BuildAll.bat
```

Optional environment variables:

- `SKSE64_SRC` — folder with `common`, `skse64`, `skse64_common`, loaders
- `SKSEVR_SRC` — optional; only links the old `sksevr\plugin` tree if you still use `sksevr.sln` for reference (not required for `BuildAll.bat`)
- `SKYRIM_SE` — Skyrim AE install path for Papyrus compile

## Native targets

| MSBuild configuration | SKSE runtime | Output folder |
|----------------------|--------------|---------------|
| `Release_Steam1170` | Steam 1.6.1170 | `Plugins/Skyrim AE Plugin` |
| `Release_GOG1179` | GOG 1.6.1179 | `Plugins/Skyrim AE GOG Plugin` |
| `Release_Old640` | Steam 1.6.640 | `Plugins/Skyrim AE Old Plugin` |
| `CrowdControlPluginVR` Release | SKSEVR (game 1.4.15) | `Plugins/Skyrim VR Plugin` |

Target selection is defined in `Source/DLL/configs/Runtime.*.props` and `plugin/include/SkyrimTargetConfig.h`. The VR plugin uses the same SKSE64 headers/libs as AE but sets `CC_TARGET_VR` (VR log path, no `SKSEPlugin_Version` export — same pattern as the old VR pack).

**VR runtime note:** Game struct offsets in `GamePause.cpp` / `main.cpp` were tuned on AE. If pause detection misbehaves in VR, you may need VR-specific offsets or a SKSEVR-era `GameAPI` tree; the build will still succeed with the AE SDK.

## SKSE loaders

This repo builds **CrowdControl.dll** and the Papyrus script. Full SKSE/SKSEVR loader executables still come from your SKSE distribution (or a separate SKSE build from the GOG pack tree). Copy the matching SKSE build into each `Plugins/.../Data` folder when packaging for release.

## Crowd Control app

All four `.cs` pack classes ship from this repo. Each registers a different game ID so Crowd Control can attach to the correct executable.
